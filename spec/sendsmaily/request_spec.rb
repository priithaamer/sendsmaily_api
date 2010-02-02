require File.dirname(__FILE__) + '/../spec_helper'

include FakeSendsmaily

describe Sendsmaily::Request, 'call' do
  
  it 'should parse service results into response object' do
    fake_successful_multiopt_request
    
    request = Sendsmaily::Request.new('multi-opt-in')
    response = request.call
    
    response.should be_success
    response.message.should eql('OK')
  end
  
end