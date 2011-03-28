require 'rubygems'
require 'sinatra'
require 'data_mapper'

# gem install sqlite do_sqlite3 datamapper
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/exante.db")

class Event
	
	include DataMapper::Resource
	
	property :id,				Serial
	property :title,			String
	property :description,		Text
	property :start_date,		DateTime
	property :start_time,		DateTime
	property :end_date,			DateTime
	property :end_time,			DateTime
	property :all_day,			Boolean
	property :location,			Text
	property :guest_list,		Text
	property :private_event,	Boolean
	
end

DataMapper.auto_upgrade!

get '/' do
	@title = "Welcome"
	erb :home
end

get '/event/new' do
	@title = "Create new event"
	erb :new_event
end

post '/list' do
	@title = "List all events"
	erb :list
end
