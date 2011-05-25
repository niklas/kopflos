require 'kopflos/xvfb'

module Kopflos
  class AlreadyRunning < Exception; end

  def self.start(opts={})
    if running?
      unless opts[:reuse]
        raise AlreadyRunning, "there is already a server running: #{@server}"
      end
    else
      @server = Xvfb.new(opts)
      @server.start
      @server
    end
  rescue Xvfb::NotSupported => e
    STDERR.puts "your platform is not supported (yet): #{RUBY_PLATFORM}"
  end

  def self.stop
    if running?
      @server.stop
      @server = nil
    end
  end

  def self.running?
    @server && @server.running?
  end

  def self.reset!
    stop
    @server = nil
  end
end
