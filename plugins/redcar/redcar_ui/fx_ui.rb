require 'jrubyfx'
require 'java'
require_relative 'menubar'

fxml_root Redcar::FXML_Root_Files.directory

module FX_UI
  class App < JRubyFX::Application
    def start(stage)
      with(stage, title: "Redcar", width: 800, height: 600) do
        fxml MainController
        show
        set_on_close_request(CloseRequest.new)
      end
    end
  end

  private

  class MainController
    include JRubyFX::Controller
    include Menubar

    fxml 'main.fxml'
  end

  class CloseRequest
    include EventHandler

    def handle(e)
      e.consume
    end
  end
end