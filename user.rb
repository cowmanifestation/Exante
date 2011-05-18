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
	@users = User.all(:order => [:user.asc])
	erb :list_users
end

# New user form
get '/user/new' do
	@title = "Create new user..."
	erb :new_user
end

# Create user
post '/user/create' do
	user = User.new
	user.user = params[:user]
	user.password = params[:password]
	user.first_name = params[:first_name]
	user.last_name = params[:last_name]
	user.email = params[:email]

	user.status = true

	# Serverside Validation
	return unless (user.user && user.password && user.password == params[:cpassword])

	if user.save
		status 201
		redirect '/user/' + user.id.to_s
	else
		status 412
		redirect '/user/all'
	end

end

# View user
get '/user/:id' do
	@user = User.get(params[:id])

	@title = "View User : " + @user.user

	erb :view_user
end

