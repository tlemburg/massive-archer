require 'sinatra'
require 'pp'
require 'active_record'
require 'rss'
require 'open-uri'

class NewsItem < ActiveRecord::Base
  
end

get '/' do
	erb :index
end

get '/scan' do
  out = []

  # get the list of RSS feeds
  feeds = [
    'http://www.omaha.com/search/?q=&t=article&l=25&d=&d1=&d2=&s=start_time&sd=desc&c[]=huskers/football*&f=rss',
    'http://www.huskers.com/rss.dbml?db_oem_id=100&RSS_SPORT_ID=22&media=news',
    'http://espn.go.com/blog/feed?blog=collegesnebraska'
  ]

  feeds.each do |url|
    open(url) do |rss|
        feed = RSS::Parser.parse(rss, false)

        feed.items.each do |item|
            guid = item.guid.content
            if NewsItem.where(:guid => guid).first.nil?
                new_item = NewsItem.create(
                    :title => item.title,
                    :guid => guid,
                    :link => item.link,
                    :original_publish_date => item.pubDate
                )
                out << 'Inserted article with title: ' + item.title
            else 
                out << 'Skipped article with title: ' + item.title
            end
        end
    end
  end

  out.join('<br>')
end
