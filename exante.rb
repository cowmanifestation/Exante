require 'rubygems'
require 'sinatra'


get '/' do
	@title = "Welcome"
	erb :home
end

get '/create' do
	@title = "Create new event"
	erb :create
end

post '/list' do
	@title = "List all events"
	erb :list
end
