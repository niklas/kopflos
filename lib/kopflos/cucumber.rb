require 'kopflos'

Before '@javascript' do |scenario|
  Kopflos.start
end

at_exit do
  Kopflos.stop
end
