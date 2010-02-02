# Parses Sendsmaily response objects which are represented in JSON form 
#
#   {"code":101,"message":"OK"}
#
class Sendsmaily::Response
  
  attr_accessor :response
  
  def initialize(http_response)
    @response = http_response
  end
  
  def success?
    response.code.to_s == '200' && response.body.match(/"message":"OK"/)
  end
  
  # TODO: it should parse JSON with Ruby JSON or ActiveSupport::JSON
  def message
    response.body.match(/"message":"(.*)"/)[1]
  end
  
end