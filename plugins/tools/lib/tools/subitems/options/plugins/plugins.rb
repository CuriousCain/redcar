require 'jrubyfx'

java_import javafx.scene.layout.AnchorPane
java_import javafx.collections.FXCollections
java_import javafx.scene.control.TableView

class PluginsController < AnchorPane
  def initialize
    super

    data_list = FXCollections.observable_array_list

    data_list.add Redcar.plugin_manager.plugins

    plugins_table = TableView.new data_list

    get_children.add plugins_table
  end
end