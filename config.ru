require 'active_record'
require 'open-uri'
require 'sinatra'
require 'rss'
require 'redcarpet'
require 'curb'
require 'stripe'

Dir['./models/*'].each {|f| require f}
Dir['./utils/*'].each {|f| require f}
require './app'

ENV['RACK_ENV'] = ENV['RACK_ENV'] || 'development'
ENV['STRIPE_TEST_KEY'] = ENV['STRIPE_TEST_KEY'] || 'pk_test_C1nkt9dG6QEJfyHjiwnZ1MWc'
# read the stripe secret from the config file, if it doesn't exist.
if !ENV['STRIPE_TEST_SECRET'] 
    ENV['STRIPE_TEST_SECRET'] = JSON.parse(File.read('./.config/config.json'))['stripe_test_secret']
end

if ENV['RACK_ENV'] == 'production'
  ActiveRecord::Base.establish_connection(ENV['CLEARDB_DATABASE_URL'])
else
  ActiveRecord::Base.establish_connection({
    :adapter => 'mysql',
    :host => 'localhost',
    :username => 'root',
    :password => '',
    :database => 'massive_archer',
  })
end

run Sinatra::Application 
