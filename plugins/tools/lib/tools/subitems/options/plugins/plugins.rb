require 'jrubyfx'
require_relative './plugin_helper'

java_import javafx.scene.layout.AnchorPane
java_import javafx.collections.FXCollections
java_import javafx.scene.control.TableView
java_import javafx.scene.control.TableColumn
java_import javafx.scene.control.cell.MapValueFactory
java_import javafx.beans.value.ChangeListener
java_import javafx.scene.control.Label
java_import javafx.scene.control.Button
java_import javafx.event.EventHandler

module Plugins_Option
  class PluginsController < AnchorPane
    def initialize
      super

      data_list = FXCollections.observable_array_list

      Redcar.plugin_manager.plugins.each do |plugin|
        data_list.add({:plugin_name => plugin.name, :plugin_object => plugin})
      end

      plugins_column = TableColumn.new 'Plugin'
      plugins_column.set_cell_value_factory MapValueFactory.new :plugin_name

      plugins_table = TableView.new data_list
      plugins_table.get_columns.add_all plugins_column
      plugins_table.set_column_resize_policy TableView::CONSTRAINED_RESIZE_POLICY

      name_label = Label.new
      name_label.set_translate_x 300
      name_label.set_translate_y 25

      version_label = Label.new
      version_label.set_translate_x 300
      version_label.set_translate_y 40

      status_label = Label.new
      status_label.set_translate_x 300
      status_label.set_translate_y 55

      toggle_plugin_button = Button.new
      toggle_plugin_button.set_translate_x 300
      toggle_plugin_button.set_translate_y 75

      button_on_action = Plugin_Button_On_Action.new name_label, version_label, status_label, toggle_plugin_button
      toggle_plugin_button.set_on_action button_on_action

      table_change_listener = Plugins_Table_Change_Listener.new name_label, version_label, status_label, toggle_plugin_button
      plugins_table.get_selection_model.selected_item_property.add_listener table_change_listener

      get_children.add_all plugins_table, name_label, version_label,
                           status_label, toggle_plugin_button

      plugins_table.get_selection_model.select_first
    end
  end

  private

  class Plugin_Button_On_Action
    include EventHandler

    def initialize(name_label, version_label, status_label, toggle_plugin_button)
      @name_label = name_label
      @version_label = version_label
      @status_label = status_label
      @toggle_plugin_button = toggle_plugin_button
    end

    def handle(e)
      enabled_status = Redcar.plugin_manager.loaded_plugins.include? PluginHelper.selected_plugin

      if enabled_status
        dependencies = Redcar.plugin_manager.derivative_plugins_for(PluginHelper.selected_plugin) & Redcar.plugin_manager.loaded_plugins

        if dependencies.empty?
          Redcar.plugin_manager.loaded_plugins.reject! { |plugin| plugin == PluginHelper.selected_plugin }
          Redcar.plugin_manager.disabled_plugins = Redcar.plugin_manager.disabled_plugins.collect!(&:name) + [PluginHelper.selected_plugin.name]
          PluginHelper.save_disabled_plugins
          @status_label.set_text "Disabled"
          @toggle_plugin_button.set_text "Enable"
        else
          puts "PLUGIN IS NEEDED BY OTHER PLUGINS: #{dependencies}"
        end
      else
        disabled_plugins = Redcar.plugin_manager.disabled_plugins.collect &:name
        dependencies = PluginHelper.selected_plugin.dependencies.collect(&:required_name) & disabled_plugins

        if dependencies.empty?
          PluginHelper.reload_plugin PluginHelper.selected_plugin.name
          Redcar.plugin_manager.disabled_plugins = disabled_plugins - [PluginHelper.selected_plugin.name]
          PluginHelper.save_disabled_plugins
          @status_label.set_text "Enabled"
          @toggle_plugin_button.set_text "Disable"
        else
          puts "PLUGIN DEPENDENCIES ARE NOT SATISFIED: #{dependencies}"
        end
      end
    end
  end

  class Plugins_Table_Change_Listener
    include ChangeListener

    def initialize(name_label, version_label, status_label, toggle_plugin_button)
      @name_label = name_label
      @version_label = version_label
      @status_label = status_label
      @toggle_plugin_button = toggle_plugin_button
    end

    def changed(observable, old_value, new_value)
      PluginHelper.selected_plugin = new_value[:plugin_object]

      @name_label.set_text new_value[:plugin_object].name
      @version_label.set_text "Version #{new_value[:plugin_object].version}"

      enabled_status = Redcar.plugin_manager.loaded_plugins.include? new_value[:plugin_object]

      if enabled_status
        @status_label.set_text "Enabled"
        @toggle_plugin_button.set_text "Disable"
      else
        @status_label.set_text "Disabled"
        @toggle_plugin_button.set_text "Enable"
      end
    end
  end
end