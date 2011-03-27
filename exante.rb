require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

# gem install sqlite do_sqlite3 datamapper
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/exante.db")

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
	property :guest_list,		String
	property :private_event,	Boolean
	
end

DataMapper.auto_upgrade!

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
