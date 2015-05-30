require 'jrubyfx'
require 'java'

fxml_root File.dirname(__FILE__)

java_import java.lang.Runnable
java_import javafx.application.Platform
java_import javafx.stage.Stage

class OptionsCommand < Redcar::Command
  def execute
    Platform.run_later OptionsWindow.new
  end
end

class OptionsWindow
  include Runnable

  def run
    stage = Stage.new
    stage.fxml OptionsController
    stage.title = 'Options'

    stage.show
  end
end

class OptionsController
  include JRubyFX::Controller
  fxml 'options.fxml'

  def initialize
    puts "INITIALIZED OPTIONS WINDOW"
  end
end
