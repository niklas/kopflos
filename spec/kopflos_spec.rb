require 'spec_helper'

describe "Kopflos" do
  it "should default to Xvfb" do
    @xvfb = mock("Xvfb")
    @xvfb.should_receive(:start).and_return(true)
    @xvfb.stub!(:running?).and_return(true)
    @xvfb.stub!(:stop).and_return(true)
    Kopflos::Xvfb.should_receive(:new).once.and_return(@xvfb)
    Kopflos.start
  end

  it "should do nothing when stopping without having started" do
    lambda {
      Kopflos.stop
    }.should_not raise_error
  end

  it "should not start if disabled by environment variable" do
    Kopflos.stub(:disabled_by_env_variable?).and_return(true)
    Kopflos::Xvfb.should_not_receive(:new)
    Kopflos.start
  end

  context "environment variable" do
    before do
      @old_env = ENV['KOPFLOS']
    end
    after do
      ENV['KOPFLOS'] = @old_env
    end

    %w(disabled disable 0 false no).each do |off_switch|
      it "disables kopflos if set to '#{off_switch}'" do
        ENV['KOPFLOS'] = off_switch
        Kopflos.should be_disabled_by_env_variable
      end
    end

    %w(enable enabled 1 true yes fnord).each do |off_switch|
      it "does not disable kopflos if set to '#{off_switch}'" do
        ENV['KOPFLOS'] = off_switch
        Kopflos.should_not be_disabled_by_env_variable
      end
    end
  end

  it "should not start if disabled by switch file" do
    Kopflos.stub(:disabled_by_switch_file?).and_return(true)
    Kopflos::Xvfb.should_not_receive(:new)
    Kopflos.start
  end

  context "switch file in working dir" do
    let(:switch_file) { Kopflos.switch_file_path }
    after :each do
      FileUtils.rm_f switch_file
    end

    it "is not checked in subdirs" do
      Kopflos.switch_file_path.should_not include('/')
    end

    context "not existing" do
      it "should not disable Kopflos" do
        Kopflos.should_not be_disabled_by_switch_file
      end
    end

    context "existing" do
      it "should disable kopflos" do
        FileUtils.touch switch_file
        Kopflos.should be_disabled_by_switch_file
      end
    end
  end

  describe "started" do
    before :each do
      @server = mock("Kopflos::Server")
      @server.stub!(:start).and_return(true)
      @server.stub!(:stop).and_return(true)
      @server.stub!(:running?).and_return(true)
      Kopflos::Xvfb.stub!(:new).and_return(@server)
      Kopflos.start
    end

    it "should stop server with shortcut" do
      @server.should_receive(:stop)
      Kopflos.stop
    end

    it "should not allow to run another server simultanously" do
      lambda {
        Kopflos.start
      }.should raise_error(Kopflos::AlreadyRunning)
    end

    it "should allow to reuse a server" do
      lambda {
        Kopflos.start :reuse => true
      }.should_not raise_error(Kopflos::AlreadyRunning)
    end

  end

  after :each do
    Kopflos.reset!
  end
end
