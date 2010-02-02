module FakeSendsmaily

  def fake_successful_multiopt_request
    FakeWeb.register_uri(:post, 'https://test.sendsmaily.local/api/multi-opt-in', :status => [200, 'OK'], :body => '{"code":101,"message":"OK"}')
  end
  
  def fake_erroneous_multiopt_request
    FakeWeb.register_uri(:post, 'https://test.sendsmaily.local/api/multi-opt-in', :status => [500, 'Error'], :body => 'An error has occurred')
  end
  
end
