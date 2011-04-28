require 'lib/kopflos/xvfb'

x = Kopflos::Xvfb.start
system('xterm')
x.stop
