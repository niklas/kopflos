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
      end
    end

  end
end
