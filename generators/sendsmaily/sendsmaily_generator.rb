class SendsmailyGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template 'sendsmaily.rb', 'config/initializers/sendsmaily.rb'
    end
  end
end
