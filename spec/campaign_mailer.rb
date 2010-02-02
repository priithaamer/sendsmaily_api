class CampaignMailer < Sendsmaily::Mailer
  
  # Expects data as an hash in the following format:
  #
  #   {
  #     'e-mail1@example.com' => {:key1 => 'Value 1', :key2 => 'Value 2', ...},
  #     'e-mail2@example.com' => {:key1 => 'Value 3', :key2 => 'Value 4', ...}
  #   }
  def mail_values(responder_id, data = {})
    responder responder_id
    data.each do |email, args|
      add_recipient email, args
    end
  end
  
  # Expects data as an array of e-mail addresses:
  #
  #   ['e-mail1@example.com', 'e-mail2@example.com']
  #
  def plain_addresses(responder_id, data = [])
    responder responder_id
    data.each do |email|
      add_recipient email
    end
  end
end