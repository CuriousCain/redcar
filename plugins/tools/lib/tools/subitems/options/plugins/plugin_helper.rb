java_import java.lang.Runnable

module PluginHelper
  def self.save_disabled_plugins
    path = File.join Redcar.user_dir, 'storage/disabled_plugins.yaml'
    disabled = Redcar.plugin_manager.disabled_plugins.collect &:name
    File.open(path, 'w') {|io| YAML.dump disabled, io}
  end

  def self.selected_plugin
    @selected_plugin
  end

  def self.selected_plugin=(value)
    @selected_plugin = value
  end

  def self.reload_plugin(name)
    plugin = Redcar.plugin_manager.latest_version_by_name name
    plugin.load
    Redcar.plugin_manager.loaded_plugins << plugin unless
        Redcar.plugin_manager.loaded_plugins.include? plugin

    Redcar::ApplicationSWT.display.asyncExec Plugin_Refresh_Thread.new
  end

  class Plugin_Refresh_Thread
    include Runnable

    def run
      Redcar.app.refresh_menu!
    end
  end
end

