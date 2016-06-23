require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
	erb "Cap for /"
end

get '/new' do
	erb :new
end

post '/new' do
	content = params[:content]
 	erb "#{content}"
end