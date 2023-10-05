require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  encoding: 'utf8mb4',
  host:     'localhost',
  username: 'root',
  password: '',
  database: 'mlgw'
)

ActiveRecord::Base.logger = Logger.new($stdout)
Time.zone_default = Time.find_zone! 'Tokyo'
ActiveRecord.default_timezone = :local

class Paper < ActiveRecord::Base
end

get '/' do
  @papers = Paper.all
  erb :index
end

get '/register' do
  erb :register
end

post '/register' do
  year = params[:year].to_i
  month = params[:month].to_i
  day = params[:day].to_i
  begin
    published_at = Date.new(year, month, day)
  rescue ArgumentError
    erb :new
  end

  new_paper = Paper.new(
    author: params[:author],
    published_at: published_at,
    title: params[:title],
    journal: params[:journal],
    link: params[:link],
    arxiv: params[:arxiv]
  )

  if new_paper.save
    redirect '/'
  else
    erb :new
  end
end
