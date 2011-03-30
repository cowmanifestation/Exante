require 'rubygems'
#require 'bundler/setup'

require 'sinatra'
require 'data_mapper'
require 'date'

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

# set utf-8 for outgoing
before do
	headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
	@title = "Hello there!!!"
	erb :home
end

# New event form
get '/event/new' do
	@title = "Create new event, go on..."
	@script = "event.js"
	erb :new_event
end

# Create event
post '/event/create' do
	#params.inspect
	event = Event.new
	event.title = params[:title]
	event.description = params[:description]
	event.location = params[:location]
	event.guest_list = params[:guest_list]

	start_date = params[:start_date]
	event.start_date = Date.strptime(start_date, "%Y-%m-%d") unless start_date

	start_time = params[:start_time]
	event.start_time = DateTime.strptime("#{start_date} #{start_time}", "%Y-%m-%d %H:%M") unless start_time

	end_date = params[:end_date]
	event.end_date = Date.strptime(end_date, "%Y-%m-%d") unless end_date

	end_time = params[:end_time]
	event.end_time = DateTime.strptime("#{end_date} #{end_time}", "%Y-%m-%d %H:%M") unless end_time

	# TODO: Handle All day events

	if event.save
		status 201
		redirect '/event/' + event.id.to_s
	else
		status 412
		redirect '/event/all'
	end

end

# List event
get '/event/all' do
	@title = "Wow, a list of events!"
	@events = Event.all(:order => [:id.desc])
	erb :list_event
end

# View an event
get '/event/:id' do
	@event = Event.get(params[:id])

	erb :view_event
end

get '/event/:id/delete' do
	event = Event.get(params[:id])
	unless event.nil?
		event.destroy
	end
	redirect('/event/all')
end
