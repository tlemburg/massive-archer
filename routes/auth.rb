post '/login' do
  user = User.where(:username => params[:username]).first

  if user.nil?
    puts 'username does not exist'
    redirect '/'
  end

  # check the password
  if user.password != params[:password]
    puts 'wrong password'
    redirect '/'
  end

  # it is the user, hooray
  session[:user_id] = user.id
  redirect '/'
end

get '/logout' do
  session.clear
  redirect '/'
end