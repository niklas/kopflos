require 'kopflos'

Before '@javascript' do |scenario|
  Kopflos.start :reuse => true
end

at_exit do
  Kopflos.stop
end
