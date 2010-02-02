require 'net/https'
require 'uri'

class Sendsmaily::Request
  
  attr_accessor :api_method, :arguments, :response
  
  def initialize(api_method, arguments = {})
    @api_method = api_method
    @arguments = arguments
  end
  
  def call_url
    "#{Sendsmaily.url}/#{api_method}"
  end
  
  def uid
    @uid ||= Time.now.to_f.to_s
  end
  
  def call
    Sendsmaily.logger.info "Sending Request [UID: #{self.uid} URL: #{call_url}] \n#{arguments.inspect}\n"
    
    uri = URI.parse(call_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request_data = {'key' => Sendsmaily.api_key, 'remote' => 1}
    request_data.merge!(@arguments)
    
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(request_data)
     
    response = http.request(request)
    
    Sendsmaily.logger.info "Received Response [UID: #{self.uid}] \n#{self.response.inspect}\n"
    
    Sendsmaily::Response.new(response)
  rescue
    Sendsmaily.logger.error "Failure [UID: #{self.uid}] \n#{$!.inspect}"
    return nil
  end
  
end
