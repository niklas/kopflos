require 'kopflos'

@exit_code = 0

Before '@javascript' do |scenario|
  Kopflos.start :reuse => true
end

After do |scenario|
  @exit_code = 1 if scenario.failed?
end

at_exit do
  Kopflos.stop
  exit(@exit_code)
end
