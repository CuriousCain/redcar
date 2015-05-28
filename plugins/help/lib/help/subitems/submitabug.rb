require 'launchy'

class SubmitABugCommand < Redcar::Command
  def execute
    Launchy.open 'https://redcar.lighthouseapp.com/projects/25090-redcar/tickets/new'
  end
end