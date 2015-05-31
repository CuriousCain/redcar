require 'jrubyfx'

java_import javafx.scene.layout.AnchorPane
java_import javafx.scene.control.TableView
java_import javafx.scene.control.TableColumn

class KeybindingsController < AnchorPane
  def initialize
    super

    key_table = TableView.new
    action_column = TableColumn.new 'Action'
    keybind_column = TableColumn.new 'Shortcut'

    key_table.get_columns.set_all action_column, keybind_column

    get_children.add key_table
  end
end
