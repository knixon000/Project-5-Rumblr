require 'sinatra'
require "sinatra/reloader"

# Run this script with `bundle exec ruby app.rb`
require 'sqlite3'
require 'active_record'

#require model classes
# require './models/cake.rb'
require './models/user.rb'

# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'
require 'csv'

# Connect to a sqlite3 database
# If you feel like you need to reset it, simply delete the file sqlite makes
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.db'
)

register Sinatra::Reloader
enable :sessions

get '/' do
  erb :index
end

get '/homepage' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    erb :homepage
  else
    erb :index
  end
end

post '/users/login' do
  user = User.find_by(email: params["email"], password: params["password"])
  if user
    session[:user_id] = user.id
    redirect '/homepage'
  else
    redirect '/'
  end
end

get '/users/logout' do
  session[:user_id] = nil
  redirect '/'
end

get '/users/signup' do
  erb :index
end

post '/users/signup' do
  new_user = User.create(first_name: params["first-name"], last_name: params["last-name"], email: params["signup-email"], birthday: params["dob"], password: params["signup-password"])
  session[:user_id] = new_user.id
  redirect '/homepage'
end
