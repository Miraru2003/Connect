require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

enable :sessions

before '/tasks' do
    if current_user.nil?
        redirect '/'
    end
end

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
    if current_user.nil?
        @tasks = Task.none
    else
        @tasks = current_user.tasks
    end
    erb :index
end

get '/signup' do
    erb :sign_up
end

post '/signup' do
    user = User.create(
        name: params[:name],
        mail: params[:mail],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
        )
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/'
end

get '/signin' do
    erb :sign_in
end

post '/signin' do
    user = User.find_by(mail: params[:mail])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end

get '/newtweet' do
    erb :maketweet
end

post '/tasks' do
    current_user.tasks.create(
    beforestarting: Date.parse(params[:beforestarting]),
    deadline: Date.parse(params[:deadline]),
    voting: Date.parse(params[:voting]),
    result: Date.parse(params[:result]))
    @error= nil
    if (Date.parse(params[:deadline]) - Date.today) < ( Date.parse(params[:beforestarting]) - Date.today)
        @error ="設定された日時の順番に問題があります。"
        redirect '/newtweet'
    elsif (Date.parse(params[:voting]) - Date.today) < ( Date.parse(params[:deadline]) - Date.today)
        @error ="設定された日時の順番に問題があります。"
        redirect '/newtweet'
    elsif (Date.parse(params[:result]) - Date.today) < ( Date.parse(params[:voting]) - Date.today)
        @error ="設定された日時の順番に問題があります。"
        redirect '/newtweet'   
    else
        current_user.tasks.create(title: params[:tweet])
         redirect '/competetions'
end
    end

post '/tasks/:id/delete' do
    task = Task.find(params[:id])
    task.destroy
    redirect '/competetions'
end

get '/tasks/:id/edit' do
    @task = Task.find(params[:id])
    erb :edit
end

get '/tasks/new' do
    erb :maketweet
end

get '/home' do
    erb :home
end

get '/news' do
    erb :news
end

get '/topmenu' do
    erb :topmenu
end

get '/competetions' do
    if current_user.nil?
        @tasks = Task.none
    else
        @tasks = Task.all
    end 
    erb :competitions
end

get '/mypage' do
    if current_user.nil?
        @tasks = Task.none
    else
        @tasks = current_user.tasks
    end 
    erb :mypage
end
