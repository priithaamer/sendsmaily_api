require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../campaign_mailer'

describe Sendsmaily::Mailer, 'deliver' do
  
  it 'should build object request object with parameter structure specified in sendsmaily api' do
    Sendsmaily::Request.should_receive(:new).with('multi-opt-in', hash_including({
      'autoresponder' => 1,
      '0[email]' => 'ex-1@example.com', '0[key1]' => 'Value 1', '0[key2]' => 'Value 2',
      '1[email]' => 'ex-2@example.com', '1[key1]' => 'Value 3', '1[key2]' => 'Value 4'
    })).once.and_return(mock(:call => true))
    
    CampaignMailer.deliver_mail_values(1, {
      'ex-1@example.com' => {:key1 => 'Value 1', :key2 => 'Value 2'},
      'ex-2@example.com' => {:key1 => 'Value 3', :key2 => 'Value 4'}
    })
  end
  
  it 'should deliver messages if only e-mail addresses, but no values have been supplied' do
    Sendsmaily::Request.should_receive(:new).with('multi-opt-in', hash_including({
      'autoresponder' => 1, '0[email]' => 'ex-1@example.com', '1[email]' => 'ex-2@example.com'
    })).once.and_return(mock(:call => true))
    
    CampaignMailer.deliver_plain_addresses(1, ['ex-1@example.com', 'ex-2@example.com'])
  end
  
  it 'should deliver messages only to Sendsmaily.recipient configuration value if set' do
    Sendsmaily.recipient = 'foo@bar.com'
    
    Sendsmaily::Request.should_receive(:new).with('multi-opt-in', hash_including({
      'autoresponder' => 1, '0[email]' => 'foo@bar.com', '1[email]' => 'foo@bar.com'
    })).once.and_return(mock(:call => true))
    
    CampaignMailer.deliver_plain_addresses(1, ['ex-1@example.com', 'ex-2@example.com'])
  end
  
  it 'should not deliver if there are no recipients' do
    Sendsmaily::Request.should_not_receive(:new)
    CampaignMailer.deliver_mail_values(1, {})
  end
  
  it 'should not deliver if responder is unset' do
    Sendsmaily::Request.should_not_receive(:new)
    CampaignMailer.deliver_mail_values(nil, {'ex-1@example.com' => {:key1 => 'Value 1', :key2 => 'Value 2'}})
  end
end

describe Sendsmaily::Mailer, 'create' do
  
  it 'should create mail object, which can be delivered later' do
    Sendsmaily::Request.should_receive(:new).with('multi-opt-in', hash_including({
      'autoresponder' => 1,
      '0[email]' => 'ex-1@example.com', '0[key1]' => 'Value 1',
      '1[email]' => 'ex-2@example.com', '1[key1]' => 'Value 2'
    })).once.and_return(mock(:call => true))
    
    mail = CampaignMailer.create_mail_values(1, {
      'ex-1@example.com' => {:key1 => 'Value 1'},
      'ex-2@example.com' => {:key1 => 'Value 2'}
    })
    CampaignMailer.deliver(mail)
  end
  
end
