require 'launchy'

module Redcar
  module Help
    class SubmitABugCommand < Redcar::Command
      def execute
        Launchy.open 'https://redcar.lighthouseapp.com/projects/25090-redcar/tickets/new'
      end
    end
  end
end