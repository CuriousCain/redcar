require 'tools/subitems/options/options'

module Redcar
  module Tools
    class ToolsMenu
      def self.menus
        Redcar::Menu::Builder.build do
          sub_menu 'Tools' do
            group(:priority => :last) do
              item 'Options', :command => Options::OptionsCommand
            end
          end
        end
      end
    end
  end
end
