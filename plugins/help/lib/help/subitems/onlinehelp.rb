require 'launchy'

module Redcar
  module Help
    class OnlineHelpCommand < Redcar::Command
      def execute
        Launchy.open 'http://github.com/redcar/redcar/wiki/Users-Guide'
      end
    end
  end
end