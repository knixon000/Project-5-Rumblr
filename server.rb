require 'sinatra'
require "sinatra/reloader"

# Run this script with `bundle exec ruby app.rb`

require 'active_record'

#require model classes
# require './models/cake.rb'
require './models/user.rb'
require './models/post.rb'
# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'
require 'csv'

# Connect to a sqlite3 database
# If you feel like you need to reset it, simply delete the file sqlite makes
if ENV['DATABASE_URL']
  require 'pg'
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  #Use sqlite since this is my computer
  require 'sqlite3'
  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'db/development.db'
  )
end

register Sinatra::Reloader
enable :sessions

get '/' do
  erb :index
end

get '/homepage' do
  @all_posts = Post.all
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

get '/users/posts' do
  erb :homepage
end

get '/profile' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    @users_posts = Post.where(user_id: @user)
    erb :profile
  else
    redirect '/'
  end
end

post '/users/posts' do
  @new_post = Post.create(user_id: session[:user_id], text_entry: params["text_entry"], tag: params["tags"])
  redirect '/profile'
end

get '/deactivate' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    erb :deactivate
  else
    redirect '/'
  end
end

get '/destroy' do
    @user = User.find(session[:user_id])
    @user.destroy
    redirect '/'
end
