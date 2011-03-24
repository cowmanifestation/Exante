require 'rubygems'
require 'sinatra'

# This is the main controller

get '/new-event' do

	erb :new_event_form

end
