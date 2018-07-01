ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  def login_as(username, password)
    status = post '/login', params: {
      username: username,
      password: password
    }, as: :json
    
    raise RuntimeError.new 'Login failed' unless status == 200
    @api_key = JSON.parse(response.body)['api-key']
  end
end
