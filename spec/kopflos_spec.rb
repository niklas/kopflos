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
end
