require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	# инициализирует базу данных
	init_db
end
# вызывается каждый раз при инициализации приложения:
# когда изменился код и перезагрулилась страница приложения
configure do
	# инициализация базы данных
	init_db
	# создает таблицу, если таблица не существует
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
	# получаем переменную из POST-запроса
	content = params[:content]
 	erb "#{content}"
end