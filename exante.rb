require 'rubygems'
require 'sinatra'

# This is the main controller

get '/' do
	"Welcome to Exante Project. Nothing to see here"
end

get '/new-event' do

	erb :new_event_form

end
