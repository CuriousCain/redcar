require 'tools/subitems/options/options'

module Redcar
  class Tools
    def self.menus
      Redcar::Menu::Builder.build do
        sub_menu 'Tools' do
          group(:priority => :last) do
            item 'Options', :command => OptionsCommand
          end
        end
      end
    end
  end
end
