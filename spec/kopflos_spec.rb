require 'spec_helper'

describe "Kopflos" do
  describe "starting without block" do
    it "should default to Xvfb" do
      xvfb = mock("Xvfb")
      xvfb.should_receive(:start).and_return(true)
      Kopflos::Xvfb.should_receive(:new).and_return(xvfb)
      Kopflos.start
    end
  end

  it "should do nothing when stopping without having started" do
    lambda {
      Kopflos.stop
    }.should_not raise_error
  end

  describe "started" do
    before :each do
      @server = mock("Kopflos::Server")
      @server.stub!(:start).and_return(true)
      Kopflos::Xvfb.stub!(:new).and_return(@server)
      Kopflos.start
    end

    it "should stop server with shortcut" do
      @server.should_receive(:stop)
      Kopflos.stop
    end

  end
end
