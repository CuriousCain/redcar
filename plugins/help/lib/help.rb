require 'help/subitems/about/about'
require 'help/subitems/submitabug'
require 'help/subitems/onlinehelp'

module Redcar
  module Help
    class HelpMenu
      def self.menus
        Redcar::Menu::Builder.build do
          sub_menu 'Help' do
            group(:priority => :first) do
              item 'Online Help', :command => OnlineHelpCommand
              item 'Submit a Bug', :command => SubmitABugCommand
              item 'About', :command => AboutCommand
            end

            separator

            group(:priority => :last) do
              item 'Check for updates', :command => Redcar::Application::ToggleCheckForUpdatesCommand,
                   :type => :check,
                   :checked => lambda { Redcar::Application::Updates.check_for_updates? }
              item 'Update Available', :command => Redcar::Application::OpenUpdateCommand
            end
          end
        end
      end

      def self.keymaps
        map = Redcar::Keymap.build('main', [:osx, :linux, :windows]) do
          link 'F1', OnlineHelpCommand
        end
        [map]
      end
    end
  end
end
