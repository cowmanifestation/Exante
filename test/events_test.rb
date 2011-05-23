require 'rubygems'
require 'rack/test'
require 'webrat'
require 'test/unit'
require 'contest'
require 'event'

Webrat.configure do |config|
  config.mode = :rack
end

class EventTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  def app
    Sinatra::Application.new
  end

  test "can access home page" do
    visit "/event/new"
#assert_contain("Welcome to the Cookbook!")
  end
end
