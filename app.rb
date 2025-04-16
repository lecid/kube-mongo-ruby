require 'sinatra'
require 'mongoid'
require 'json'
require 'erb'

environment  = (ENV['RACK_ENV'])? ENV['RACK_ENV'].to_sym : :development

Mongoid.load!("mongoid.yml", environment )

class Blog
  include Mongoid::Document
  field :title, type: String
  field :content, type: String
  field :created_at, type: Time, default: ->{ Time.now }
end 

data_startup = [
  {title: 'Premier Post', content: "Bienvenue sur le Blog"},
  {title: 'Deuxième post', content: " un autre post super"}
]

data_startup.each do |arecord|
  Blog.create! arecord unless Blog.where(title: arecord[:title]).exists?
end

get '/' do
  @posts = Blog.all
  erb :index
end

post '/add' do
  Blog.create! title: params[:title], content: params[:content]
  redirect '/'
end



get '/content.json' do
  content_type :json
  Blog.all.to_json

end

