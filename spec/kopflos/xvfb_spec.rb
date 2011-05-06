require 'spec_helper'

module Kopflos
  describe Xvfb do
    it "should be a class" do
      Xvfb.should be_a(Class)
    end

    it "should determine font path on initialization" do
      Xvfb.should_receive(:determine_font_path)
      Xvfb.new
    end

    describe 'new' do
      before :each do
        Xvfb.stub!(:determine_font_path).and_return('/usr/share/fonts/X11/misc')
        @xvfb = Xvfb.new
        @xvfb.stub!(:fork).and_return(23) # crazy, but seems to work
        @xvfb.stub!(:kill_server).and_return(true)
      end

      after :each do
        @xvfb.stop
      end

      it "should authorize itself on startup" do
        @xvfb.should_receive(:authorize).and_return(true)
        @xvfb.start
      end

      it "should set DISPLAY and XAUTHORITY env vars" do
        display, xauthority = ENV['DISPLAY'], ENV['XAUTHORITY']
        @xvfb.start

        ENV['DISPLAY'].should_not be_nil
        ENV['DISPLAY'].should_not be_empty
        ENV['DISPLAY'].should_not == display
        ENV['XAUTHORITY'].should_not be_nil
        ENV['XAUTHORITY'].should_not be_empty
        ENV['XAUTHORITY'].should_not == xauthority
      end
    end

  end
end
