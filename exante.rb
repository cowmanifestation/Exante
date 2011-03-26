require 'rubygems'
require 'sinatra'


get '/' do
	erb :home
end

get '/create' do
	erb :create
end

get '/list' do
	erb :list
end
