require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb "Cap for /"
end

get '/new' do
  erb "Cap for /new"
end

