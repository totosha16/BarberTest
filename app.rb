#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'yaml'
require 'nokogiri'
require 'open-uri'
require 'date'

def surgery opt

	begin
		html = Nokogiri::HTML(open(opt[:url]))

		@price=nil

		@price=html.css(opt[:cssP]) if opt[:cssP]
		if opt[:xpathP] && @price
			@price=@price.xpath(opt[:xpathP]).text.gsub(/\D/,"").to_i
			@price=@price.round
		elsif @price==nil && opt[:xpathP]
			@price=html.xpath(opt[:xpathP]).text.gsub(/\D/,"").to_i
			@price=@price.round
		elsif @price==nil
			@price='Path Error'
		else
			@price=@price.text.gsub(/\D/,"").to_i
			@price=@price.round
		end
				
	rescue
			@price='Page open Error'
	end

end

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

get '/test' do

	@url_test = ""
	@css_test = ""
	@xpath_test = ""

	erb :test
end

post '/test' do
	@url_test = params[:url_test]
	@css_test = params[:css_test]
	@xpath_test = params[:xpath_test]


	#@url_test="" if @url_test==""


	data={:url=>@url_test,
		:cssP=>@css_test,
		:xpathP=>@xpath_test}
		surgery data

	erb :test

end