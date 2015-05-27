require 'jrubyfx'
require 'java'

fxml_root File.dirname(__FILE__)

java_import java.lang.Runnable
java_import javafx.application.Platform
java_import javafx.stage.Stage

class AboutCommand < Redcar::Command
  def execute
    Platform.run_later AboutWindow.new
  end
end

class AboutWindow
  include Runnable

  def run
    stage = Stage.new
    stage.fxml AboutController
    stage.title = "About Redcar"

    stage.show
  end
end

class AboutController
  include JRubyFX::Controller
  fxml 'about.fxml'

  def initialize
    @lblVersion.text = "Version: #{Redcar::VERSION}"
    @lblRuby.text = "Ruby Version: #{RUBY_VERSION}"
    @lblJruby.text = "JRuby Version: #{JRUBY_VERSION}"
    @lblEnvironment.text = "Redcar Environment: #{Redcar.environment}"
  end
end