require 'sinatra'
require 'pp'
require 'xmlsimple'
require 'activerecord'


class NewsItem < ActiveRecord::Model
  
end

get '/' do
	erb :index
end

get '/scan' do
  # get the list of RSS feeds
  feeds = [
    'http://www.omaha.com/search/?q=&t=article&l=25&d=&d1=&d2=&s=start_time&sd=desc&c[]=huskers/football*&f=rss'
  ]

  out = ''

  feeds.each do |feed|
    xml_data = Net::HTTP.get_response(URI.parse(feed)).body
    data = XmlSimple.xml_in(xml_data)

    

    out << pp(data.inspect)
  end

  out
  
end
