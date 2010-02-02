$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'spec'
require 'sendsmaily'
require 'fakeweb'

Spec::Runner.configure do |config|
  config.before(:each) do
    Sendsmaily.configure do |config|
      config.api_key = 'peterhadalittledognamedfartsy'
      config.account = 'test'
      config.url = 'https://test.sendsmaily.local/api'
      config.recipient = nil
      config.logger = Logger.new("#{File.expand_path('../tmp', File.dirname(__FILE__))}/spec.log")
    end
  end
end

# Disables all outgoing requests so we don't have to worry sending too much messages to santa claus :)
FakeWeb.allow_net_connect = false

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }