ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require File.expand_path(File.dirname(__FILE__) + '/blueprints')
require 'rails/test_help'

class ActiveSupport::TestCase
  # Reset the Machinist cache before each test.
  setup { Machinist.reset_before_test }

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login!(options = {})
    user = User.make(options)
    @request.session[:user_id] = user.id
    user
  end

  # TODO remove when all moved over to machinist
  def login_as(user)
    @request.session[:user_id] = user ? users(user).id : nil
    @request.session[:online_at] = Time.now.utc
  end

  def private_site
    settings = Setting.find(:first)
    settings.destroy
  end
end
