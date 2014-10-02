use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :expire_after => 2.hours, # In seconds # may want to modify this.
                           :secret => 'janewaychakotay',
                           :old_secret => 'janewaychakotay'

before do


  if session.has_key?(:user_id)
    @user = User.find(session[:user_id])
    @temp_user = nil
  else
    @user = nil
    # here we will see if the user is a "temp user"
    # Pretty simple: for now we will drop a cookie on them ## YUM! cookies!
    # that will reference a temporary user with a unique key
    if cookies[:temp_user_key].nil? || (this_user = TempUser.find_by(:key => cookies[:temp_user_key])).nil?
      # create and assign a new temp user
      key = (1..20).to_a.map{(Random.rand(26) + 65).chr}.join
      @temp_user = TempUser.create({
        :key => key,
        :valid_until => Time.now + 1.week
      })
      cookies[:temp_user_key] = key
      puts cookies.inspect
    else
      # this is a known temp user
      @temp_user = this_user
    end
  end
  puts @temp_user.inspect
end

Dir['./routes/*'].each {|f| require f}