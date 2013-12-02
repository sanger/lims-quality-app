require "lims-quality-app"
require "rack/test"
require "hashdiff"
require "json"

#set :environment, :test
#set :run, false
#set :raise_errors, true
#set :logging, false

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
