ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all
end

module SignInHelper
  def sign_in_as(user)
    post login_users_url(user: { username: user.email, password: '123456789' })
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end