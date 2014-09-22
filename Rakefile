require 'active_record'
require 'yaml'

ENV["RACK_ENV"] = ENV['RACK_ENV'] || 'development'

task :default => :migrate
 
desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end
 
task :environment do
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

	require './website/models/news_item'
	end

	
end
