require "spec_helper"

describe Redcar::Gui do
  before do
    Redcar::Gui.all.clear
    @gui = Redcar::Gui.new("test gui")
  end
  
  it "has a name" do
    expect(@gui.name).to eq("test gui")
  end
  
  it "registers itself" do
    expect(Redcar::Gui.all.map {|g| g.name}).to eq(["test gui"])
  end
  
  it "delegates start and stop to the event loop" do
    event_loop = Swt::EventLoop.new
    allow(event_loop).to receive(:start)
    allow(event_loop).to receive(:stop)
    
    @gui.register_event_loop(event_loop)
    
    @gui.start
    @gui.stop
  end
end