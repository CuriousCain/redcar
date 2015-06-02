java_import java.lang.Runnable
# $:.push(File.expand_path(File.join(File.dirname(__FILE__),
#   "vendor", "activesupport-3.0.3", "lib")))
#
# require 'active_support'
# require 'active_support/inflections'
module Redcar
  # This class is your plugin. Try adding new commands in here
  # and putting them in the menus.
  class KeyBindings
    
    def self.user_keybindings
      key_bindings = key_binding_prefs.inject({}) do |h, (command_class, key)|
        begin
          h[command_class] = key
        rescue
          Redcar.log.warn "invalid key binding from \"#{key}\" to #{command_class.inspect} in file \"#{@storage.send(:path)}\""
        end
        h
      end
      key_bindings
    end
    
    def self.storage
      @storage ||= Plugin::Storage.new('key_bindings')
    end
    
    def self.key_binding_prefs
      storage["key_bindings"] ||= {}
    end
    
    def self.add_key_binding(key, command)
      key_binding_prefs[command] = key
      storage.save
      ApplicationSWT.display.asyncExec Menu_Refresh_Thread.new
    end
  end

  class Menu_Refresh_Thread
    include Runnable

    def run
      Redcar.app.refresh_menu!
    end
  end
end
