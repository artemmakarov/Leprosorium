require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts 
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
 		created_date DATE,
 		content TEXT
 	)'
end

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