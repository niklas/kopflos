require 'kopflos/xvfb'

module Kopflos
  def self.start(opts={})
    @server = Xvfb.new(opts)
    @server.start
    @server
  end
end
