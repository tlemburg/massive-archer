require './website/app'

ENV['RACK_ENV'] = ENV['RACK_ENV'] || 'development'

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

require './website/models/news_item'

run Sinatra::Application 
