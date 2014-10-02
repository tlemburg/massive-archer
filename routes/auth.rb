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

get '/create-account' do 
  erb :create_account
end

post '/create-account' do
  # check for already existing username:
  unless User.find_by(:username => params[:username]).nil?
    puts 'user with username already exists'
    redirect '/create-account'
  end

  Stripe.api_key = ENV['STRIPE_TEST_SECRET']

  # need to send this token up to stripe to create a recurring subscription
  customer = Stripe::Customer.create(
    {
      :card => params[:stripeToken],
      :plan => 'standard',
      :email => params[:stripeEmail]
    }
  )

  u = User.new({
    :username => params["username"],
    :is_admin => false,
    :is_reviewer => false,
    :subscription_valid => true,
    :stripe_customer_id => customer.id
  })

  u.password = params[:password]
  u.save

end