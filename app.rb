#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'yaml'


get '/' do
	erb "Hello!! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/add' do
	erb :add
end

post '/add' do

	@name = params[:name]
	@phone = params[:phone]
	@mail = params[:mail]

			book = YAML::load_file "book.yml"
			book[@name]=[@phone,@mail]

			File.open("book.yml", "w") do |file|
			file.write book.to_yaml
			end

	@title = 'Поздравляем!'
	@message = "Контакт #{@username} добавлен в записную книжку"


	hh = { 	:name => 'Введите имя',
			:phone => 'Введите телефон',
			:mail => 'Введите E-mail' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :add
	end


	erb :messg
end

get '/find' do

	@hideinfo = "hidden"
	@hidealert = "hidden"

	@testt = "alert alert-danger"
	erb :find
end

post '/find' do

	@name = params[:name]

	book = YAML::load_file "book.yml"
	if book[@name]
		@phone = book[@name][0]
		@mail = book[@name][1]

		@hideinfo = ""
		@hidealert = "hidden"

		erb :find
	else
		@hidealert = ""
		@hideinfo = "hidden"

		erb :find
	end

end