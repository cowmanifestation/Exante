require 'event'
require 'capybara'
require 'capybara/dsl'
require 'test/unit'

class TestEvent < Test::Unit::TestCase
  include Capybara

  def setup
    Capybara.app = Sinatra::Application.new
  end

  def test_event
    visit "/event/all"
    assert page.has_content?('Wow, a list of events!')
  end

  def test_form_entry
    title = "Surprise Party"

    visit '/event/new'
    fill_in 'title', :with => title
    click_button 'Create'
    assert page.has_content? title
  end
end
