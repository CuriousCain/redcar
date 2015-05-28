require 'launchy'

class OnlineHelpCommand < Redcar::Command
  def execute
    Launchy.open 'http://github.com/redcar/redcar/wiki/Users-Guide'
  end
end