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

 	@db.execute 'CREATE TABLE IF NOT EXISTS Comments 
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
 		created_date DATE,
 		content TEXT,
 		post_id INTEGER

 	)'
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
	# получаем переменную из url
	post_id = params[:post_id]
   
    # получаем список постов
	results = @db.execute 'select * from Posts where id = ?', [post_id]
	# выбираем один пост в переменную @row
	@row = results[0]

	# выбираем комментарии для нашего поста
	@comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

	# возвращаем представление details.erb
	erb :details
end

post  '/details/:post_id' do
	# получаем переменную из url
	post_id = params[:post_id]

   # получаем переменную из POST-запроса
	content = params[:content]


	#сохраняем данные в БД
	@db.execute 'insert into Comments 
		(
		content, 
		created_date, 
		post_id
		) 
		values 
		(
		?, 
		datetime(),
		?
		)', [content, post_id]

	redirect to('/details' + post_id)


end
