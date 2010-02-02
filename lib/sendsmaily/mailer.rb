# Mailer object can take multiple e-mail addresses with multiple values and queues them to the Sendsmaily service for
# sending.
#
# Mailer works in the same manner as ActionMailer::Base, but differs in several aspects depending how the Sendsmaily
# service works. First, e-mails are being rendered in Sendsmaily, therefore all you need to send is a bunch of e-mail
# addresses and optional values that will be rendered inside e-mail body.
#
# == Example
#
# Set up mailer class similar to ActionMailer, but make sure it inherits Sendsmaily::Mailer
#
#   class SantaClausMailer < Sendsmaily::Mailer
#     def gift_message
#       responder 1
#       add_recipient 'santa-claus@example.com', {:key1 => 'Value', :key2 => 'Value'}
#       add_recipient 'fake-santa@example.com', {:key1 => 'Value', :key2 => 'Value'}
#     end
#   end
#
# To deliver the messages
#
#   SantaClausMailer.deliver_gift_message
#
class Sendsmaily::Mailer
  
  @@perform_deliveries = true
  
  attr_reader :mail
  
  class << self
    
    def method_missing(method_name, *parameters) #:nodoc:
      if match = /^(create|deliver)_([_a-z]\w*)/.match(method_name.to_s) || /^(new)$/.match(method_name.to_s)
        case match[1]
        when 'create' then new(match[2], *parameters).mail
        when 'deliver' then new(match[2], *parameters).deliver!
        when 'new' then nil
        else super
        end
      else
        super
      end
    end
    
    def deliver(mail)
      new.deliver!(mail)
    end
    
  end
  
  def initialize(method_name = nil, *parameters)
    @arguments = {}
    @index = 0
    
    create!(method_name, *parameters) if method_name
  end
  
  def create!(method_name, *parameters)
    __send__(method_name, *parameters)
    create_mail
  end
  
  # Builds mail object and returns it
  def create_mail
    if @responder && @arguments.size > 0
      @mail = Sendsmaily::Request.new('multi-opt-in', {'autoresponder' => @responder}.merge(@arguments))
    end
  end
  
  # Delivers the message(s) via Sendsmaily request
  def deliver!(mail = @mail)
    mail.call if mail && @@perform_deliveries
  end
  
  # Set responder id defined in Sendsmaily.
  def responder(responder)
    @responder = responder
  end
  
  def add_recipient(recipient, options = {})
    @arguments["#{@index}[email]"] = unless Sendsmaily.recipient.nil? then Sendsmaily.recipient else recipient end
    @arguments.merge!(options_to_sendsmaily_args(@index, options))
    @index += 1
  end

  private
  
  def options_to_sendsmaily_args(index, options = {})
    options.inject(Hash.new) do |h, val|
      h["#{index}[#{val[0]}]"] = val[1]
      h
    end
  end

end
