require 'spec_helper'

module Kopflos
  describe Xvfb do
    it "should be a class" do
      Xvfb.should be_a(Class)
    end

    it "should determine font path on initialization" do
      Xvfb.should_receive(:determine_font_path)
      Xvfb.new :wait => 1
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

      it "should set font path" do
        @xvfb.font_path.should == '/usr/share/fonts/X11/misc'
      end

      it "should have default resolution" do
        @xvfb.resolution.should == '1024x768x24'
      end

      it "should have default screen" do
        @xvfb.screen.should == '1'
      end

      it "should have a default wait time of 5s" do
        @xvfb.wait.should == 5
      end

      it "should authorize itself on startup" do
        @xvfb.should_receive(:authorize).and_return(true)
        @xvfb.start
      end

      it "should reflect its status" do
        @xvfb.start
        @xvfb.should be_running
        @xvfb.stop
        @xvfb.should_not be_running
      end

      it "should set DISPLAY and XAUTHORITY env vars" do
        display, xauthority = ENV['DISPLAY'], ENV['XAUTHORITY']
        @xvfb.authorize

        ENV['DISPLAY'].should_not be_nil
        ENV['DISPLAY'].should_not be_empty
        ENV['DISPLAY'].should_not == display
        ENV['XAUTHORITY'].should_not be_nil
        ENV['XAUTHORITY'].should_not be_empty
        ENV['XAUTHORITY'].should_not == xauthority
      end

      describe "in forked process" do
        before :each do
          @xvfb.stub!(:authorize).and_return(true)
          @xvfb.stub!(:fork).and_return(nil)
          @xvfb.stub!(:execute).and_return(true) # not really, should NOT return, it calles Kernel#exec
        end
        it "should start window manager" do
          @xvfb.should_receive(:start_window_manager).and_return(true)
          @xvfb.start
        end
      end
    end

  end
end
