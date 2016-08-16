require 'kopflos'

RSpec.configure do |config|
  config.before(:each, :js) do
    Kopflos.start :reuse => true
  end
  config.after(:suite) do
    Kopflos.stop
  end
end
