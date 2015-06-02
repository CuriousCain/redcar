require 'jrubyfx'

java_import javafx.scene.layout.AnchorPane
java_import javafx.scene.control.TableView
java_import javafx.scene.control.TableColumn
java_import javafx.collections.FXCollections
java_import javafx.scene.control.cell.MapValueFactory
java_import javafx.util.Callback
java_import javafx.util.StringConverter
java_import javafx.scene.control.cell.TextFieldTableCell
java_import javafx.scene.input.KeyEvent
java_import javafx.scene.input.KeyCode
java_import javafx.event.EventHandler

class KeybindingsController < AnchorPane
  def initialize()
    super

    data_list = FXCollections.observable_array_list

    Redcar.app.main_keymap.map.each do |k, v|
      data_list.add({ :keys => clean_name(k), :values => v, :unclean_keys => k })
    end

    key_table = TableView.new data_list
    key_table.set_editable true
    key_table.set_column_resize_policy TableView::CONSTRAINED_RESIZE_POLICY
    key_table.set_pref_width 400
    key_table.set_pref_height 600

    action_column = setup_action_column
    shortcut_column = setup_shortcut_column

    key_table.get_columns.set_all action_column, shortcut_column

    get_children.add key_table
  end

  def setup_action_column
    action_column = TableColumn.new 'Action'
    action_column.set_cell_value_factory MapValueFactory.new :keys
    action_column.set_cell_factory Cell_Factory_For_Map.new
    action_column.set_editable false

    action_column
  end

  def setup_shortcut_column
    shortcut_column = TableColumn.new 'Shortcut'
    shortcut_column.set_cell_value_factory MapValueFactory.new :values
    shortcut_column.set_cell_factory Cell_Factory_For_Map.new

    shortcut_column.set_on_edit_commit Shortcut_On_Edit_Commit.new

    shortcut_column
  end

  def clean_name(command)
    name = command.to_s.sub("Command","")
    index = name.rindex("::")
    unless index.nil?
      name = name[index+2,name.length]
    end
    name = name.split(/(?=[A-Z])/).map{|w| w}.join(" ").sub("R E P L","REPL")
  end
end

class Shortcut_Event_Handler
  include EventHandler

  def initialize
    @key_combo = []
  end

  def handle(e)
    if e.code == KeyCode::ENTER
      new_binding = @key_combo.join '+'
      e.get_source.update_item new_binding, false

      @key_combo.clear
    elsif e.code == KeyCode::ESCAPE
      @key_combo.clear
    else
      @key_combo.push e.code
    end
  end
end

class Shortcut_On_Edit_Commit
  include EventHandler

  def handle(e)
    new_combo = correct_modifiers(e.get_new_value)

    e.get_table_view.get_items.get(e.get_table_position.get_row)[:values] = new_combo

    command = e.get_table_view.get_items.get(e.get_table_position.get_row)[:unclean_keys]
    new_key_combo = e.get_table_view.get_items.get(e.get_table_position.get_row)[:values]

    Redcar::KeyBindings.add_key_binding new_key_combo, command
  end

  def correct_modifiers(uppercase_modifiers)
    key_combo = uppercase_modifiers
    key_combo.sub! 'CONTROL', 'Ctrl'
    key_combo.sub! 'SHIFT', 'Shift'
    key_combo.sub! 'ALT', 'Alt'

    key_combo
  end
end

class Cell_Factory_For_Map
  include Callback
  def call(p)
    cell = TextFieldTableCell.new String_Stuff.new
    cell.add_event_filter KeyEvent::KEY_PRESSED, Shortcut_Event_Handler.new

    cell
  end
end

class String_Stuff < StringConverter
  def toString(t)
    t.to_s
  end

  def fromString(string)
    string
  end
end