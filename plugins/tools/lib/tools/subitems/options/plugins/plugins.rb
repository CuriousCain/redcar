require 'jrubyfx'

java_import javafx.scene.layout.AnchorPane
java_import javafx.collections.FXCollections
java_import javafx.scene.control.TableView
java_import javafx.scene.control.TableColumn
java_import javafx.scene.control.cell.MapValueFactory

class PluginsController < AnchorPane
  def initialize
    super

    data_list = FXCollections.observable_array_list

    Redcar.plugin_manager.plugins.each do |plugin|
      data_list.add({:plugin_name => plugin.name, :version => plugin.version, :plugin_object => plugin})
    end

    plugins_column = TableColumn.new 'Plugin'
    plugins_column.set_cell_value_factory MapValueFactory.new :plugin_name

    version_column = TableColumn.new 'Version'
    version_column.set_cell_value_factory MapValueFactory.new :version

    plugins_table = TableView.new data_list
    plugins_table.get_columns.add_all plugins_column, version_column

    get_children.add plugins_table
  end
end
