require "spec_helper"

describe Redcar::Application do
  it "has a name" do
    expect(Redcar::Application::NAME).not_to be nil
  end
  
  it "has a default instance" do
    Redcar.app.is_a? Redcar::Application
  end
  
  describe "instance" do
    before do
      @app = Redcar::Application.new
      @app.controller = RedcarSpec::ApplicationController.new
    end
    
    it "creates a new window" do
      @app.new_window
      expect(@app.windows.length).to be 1
    end
  end
end
