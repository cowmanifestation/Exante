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
    visit "/event/all"
    assert_contain("Wow, a list of events!")
  end

  test "form entry" do
    title = "Surprise Party"

    visit "/event/new"
    fill_in "title", :with => title
    click_button "Create"
    assert_contain(title)
  end

  test "first event exists after adding second" do
    ["Fun", "Run", "Sun"].each do |e|
        visit "/event/new"
        fill_in "title", :with=> e
        click_button "Create"
    end
#    assert_contain("Fun")
#    assert_contain("Run")
#    assert_contain("Sun")
  end
end
