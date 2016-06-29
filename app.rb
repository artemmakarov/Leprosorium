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
 	);'
end

get '/' do
	# выбираем список постов из БД
	@results = @db.execute 'select * from Posts order by id desc'
	erb :index
end

get '/new' do
	erb :new
end

post '/new' do
	# получаем переменную из POST-запроса
	content = params[:content]
	
	if content.length == 0
		@error = 'Type text!'
		return erb :new
	end
	# сохраняем данные в БД
	@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]
	# перенаправляем на главную страницу
 	redirect to '/'
end

# вывод информации о посте

get '/details/:post_id' do
	post_id = params[:post_id]

	results = @db.execute 'select * from Posts where id = ?',[post_id]
	@row = results[0]
	erb :details
end