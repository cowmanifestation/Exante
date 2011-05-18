require 'rubygems'
require 'sinatra'
require 'data_mapper'

# Include our utility functions
require 'lib/utils'

# gem install sqlite do_sqlite3 datamapper
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/exante.db")


class User
	
	include DataMapper::Resource
	
	property :id,				Serial
	property :user,				String
	property :password,			String
	property :first_name,		String
	property :last_name,		String
	property :email,			Text
	property :status,			Boolean
	
end

DataMapper.auto_upgrade!

# set utf-8 for outgoing
before do
	headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do

	# Temporary redirect to list users 
	redirect '/user/all'
end

# List users
get '/user/all' do
	@title = "List of users!"
	@users = User.all(:order => [:id.desc])
	erb :list_users
end

