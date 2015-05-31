require 'jrubyfx'
require 'java'
require_relative 'keybindings/keybindings'

fxml_root __dir__

java_import java.lang.Runnable
java_import javafx.application.Platform
java_import javafx.stage.Stage
java_import javafx.scene.control.TreeView
java_import javafx.scene.control.TreeItem
java_import javafx.beans.value.ChangeListener
java_import javafx.scene.control.Label
java_import javafx.scene.layout.AnchorPane

class OptionsCommand < Redcar::Command
  def execute
    Platform.run_later OptionsWindow.new
  end
end

class OptionsWindow
  include Runnable

  def run
    stage = Stage.new
    stage.fxml OptionsController
    stage.title = 'Options'

    stage.show
  end
end

class OptionsController
  include JRubyFX::Controller
  fxml 'options.fxml'

  def initialize
    @optionsTreeView.set_show_root false
    @optionsTreeView.get_selection_model.selected_item_property.add_listener OptionsItemListener.new(@optionsView)
  end

  def cancel_button_clicked
    @cancelButton.get_scene.get_window.close
  end
end

class OptionsItemListener
  include ChangeListener

  def initialize(root)
    @options_view = root
  end

  def changed(observable, old_value, new_value)
    @options_view.get_children.clear

    case new_value.get_value
      when 'Keybindings'
        @options_view.get_children.add KeybindingsController.new
    end
  end
end
