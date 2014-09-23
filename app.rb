use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :expire_after => 2.hours, # In seconds # may want to modify this.
                           :secret => 'janewaychakotay',
                           :old_secret => 'janewaychakotay'

before do
  if session.has_key?(:user_id)
    @user = User.find(session[:user_id])
  else
    @user = nil
  end
end

Dir['./routes/*'].each {|f| require f}