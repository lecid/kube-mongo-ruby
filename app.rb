require 'sinatra'
require 'mongoid'
require 'json'

environment  = (ENV['RACK_ENV'])? ENV['RACK_ENV'].to_sym : :development

Mongoid.load!("mongoid.yml", environment )

class Tmp
  include Mongoid::Document
  field :name, type: String
  field :num, type: Integer
  field :val, type: Integer
end 

data_startup = [
  {name: 'one', num: 1, val: 10},
  {name: 'two', num: 2, val: 40},
  {name: 'three', num: 3, val: 30},
  {name: 'four', num: 4, val: 50},
  {name: 'five', num: 5, val: 20}] 

data_startup.each do |arecord|
  Tmp.create! arecord unless Tmp.where(name: arecord[:name]).exists?
end


get '/update' do
  "test"
end

get '/test.json' do
  content_type :json
  allTmp = Tmp.all
  allTmp.to_json
end

get '/' do
  "Hello world, %d"%Tmp.count
  end

get '/hello' do
  "Bonjour la tribu"
end
