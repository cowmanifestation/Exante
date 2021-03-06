require 'rubygems'
#require 'bundler/setup'

require 'sinatra'
require 'data_mapper'
require 'date'
require 'rest-client'

# Include our utility functions
require 'lib/utils'

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
	property :fb_event_id,		String
	
end

DataMapper.auto_upgrade!

# set utf-8 for outgoing
before do
	headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do

	# Temporary redirect till we have a dashboard
	redirect '/event/all'
	# @title = "Hello there!!!"
	# erb :home
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

	event.all_day = params[:all_day] ? true : false
	event.private_event = params[:private_event] ? true : false

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

# New event on FB
post '/event/fbcreate' do
	@title = "Create new Facebook Event"

	fb_event_id = JSON.parse(RestClient.post("https://graph.facebook.com/me/events", \
	 :access_token => params[:access_token], :name => params[:name], \
	 :description => params[:description], :start_time => params[:start_time], \
	 :end_time => params[:end_time], :location => params[:location], :privacy_type => params[:privacy_type]))

	 if params[:event_id] && fb_event_id['id']
		# Save FB event_id for future reference
		event = Event.get(params[:event_id])
		event.fb_event_id = fb_event_id['id']
		event.save
	 end

	redirect '/event/' + (params[:event_id] ? params[:event_id] : 'all')

end

# View an event
get '/event/:id' do
	@event = Event.get(params[:id])

	@title = @event.title

	# FB Integration
	# TODO: Move me to a config file
	@fb_app_id = "211428925552469"
	@script = "view_event.js"

	erb :view_event
end

# Delete event confirmation
get '/event/:id/delete' do
	@title = "Delete Event"

	@event = Event.get(params[:id])
	erb :delete_event
end

# Delete event
delete '/event/:id' do
	event = Event.get(params[:id])
	unless event.nil?
		event.destroy
	end
	redirect('/event/all')
end

# Edit event 
get '/event/:id/edit' do
	@title = "Edit event"
	@script = "event.js"

	@event = Event.get(params[:id])

	erb :edit_event
end

# Update event
put '/event/:id' do
	#params.inspect
	event = Event.get(params[:id])
	event.title = params[:title]
	event.description = params[:description]
	event.location = params[:location]
	event.guest_list = params[:guest_list]

	start_date = params[:start_date]
	event.start_date = start_date ? Date.strptime(start_date, "%Y-%m-%d") : nil

	start_time = params[:start_time]
	event.start_time = (start_date!="" && start_time!="") ? DateTime.strptime("#{start_date} #{start_time}", "%Y-%m-%d %H:%M") : nil

	end_date = params[:end_date]
	event.end_date = end_date ? Date.strptime(end_date, "%Y-%m-%d") : nil

	end_time = params[:end_time]
	event.end_time = (end_date!="" && end_time!="") ? DateTime.strptime("#{end_date} #{end_time}", "%Y-%m-%d %H:%M") : nil

	event.all_day = params[:all_day] ? true : false
	event.private_event = params[:private_event] ? true : false

	if event.save
		status 201
		redirect '/event/' + event.id.to_s
	else
		status 412
		redirect '/event/all'
	end

end

