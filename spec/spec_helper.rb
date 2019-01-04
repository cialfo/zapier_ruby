require 'bundler/setup'
require 'pry'
require 'zapier_ruby'

ZapierRuby.configure do |c|
  c.web_hooks = {
    example_zap: 'webhook_id',
    standard_example_zap: 'standard_webhook_id/uuiq'
  }
  c.enable_logging = false
end

RSpec.configure do |config|
end
