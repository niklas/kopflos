require 'kopflos/xvfb'

module Kopflos
  class AlreadyRunning < Exception; end

  EnvVar = 'KOPFLOS'

  def self.start(opts={})
    if disabled_by_env_variable?
      log "disabled through environment variable #{EnvVar} (set to anything else than 'false' or '0')"
      return
    end
    if disabled_by_switch_file?
      log "disabled through switch file #{switch_file_path} (unlink to hide the frakkin browser windows again)"
      return
    end
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
    log "your platform is not supported (yet): #{RUBY_PLATFORM}"
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

  def self.disabled_by_env_variable?
    %w(false disabled 0 disable no).include?(ENV[EnvVar].to_s)
  end

  def self.disabled_by_switch_file?
    File.exists?( switch_file_path )
  end

  def self.switch_file_path
    'kopflos_disabled'
  end

  def self.log(message)
    if ENV['LOG']
      STDERR.puts "#{self}: #{message}"
    end
  end
end
