module Sendsmaily

  require 'sendsmaily/mailer'
  require 'sendsmaily/request'
  require 'sendsmaily/response'
  require 'logger'
  
  class << self
    attr_accessor :api_key, :url, :account, :logger, :recipient
    
    # :delivery_method
    
    def url
      @url ||= "https://#{account}.sendsmaily.net/api"
    end
    
    def logger
      @logger ||= Logger.new(File.join(RAILS_ROOT, 'log', "sendsmaily_#{RAILS_ENV}.log"))
    end
    
    def configure
      yield self
    end

  end
end
