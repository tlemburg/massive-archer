before '/scan*' do
  unless !@user.nil? && @user.is_admin
    puts 'unauthorized'
    redirect '/'
  end
end

get '/scan' do
  out = []

  # get the list of RSS feeds
  feeds = {
    'OWH' => 'http://www.omaha.com/search/?q=&t=article&l=25&d=&d1=&d2=&s=start_time&sd=desc&c[]=huskers/football*&f=rss',
    'HUSKERS' => 'http://www.huskers.com/rss.dbml?db_oem_id=100&RSS_SPORT_ID=22&media=news',
    'ESPN' => 'http://espn.go.com/blog/feed?blog=collegesnebraska'
  }

  total_created = 0

  feeds.each do |name, url|
    begin
      open(url) do |rss|
        feed = RSS::Parser.parse(rss, false)

          feed.items.each do |item|
            guid = item.guid.content
            if NewsItem.find_by(:guid => guid, :feed => name).nil?
              new_item = NewsItem.create(
                :title => item.title,
                :guid => guid,
                :link => item.link,
                :feed => name,
                :reviewed => false,
                :original_publish_date => item.pubDate
              )
              out << "Inserted #{name} article with title:  #{item.title}"
              total_created += 1
            else 
              out << "Skipped #{name} article with title:  #{item.title}"
            end
          end
        end
    rescue
      out << "Error with #{name} feed, did not read"
    end
  end

  # send a notification through Airgram: only do on production for now
  begin
    if ENV['RACK_ENV'] == 'production' && total_created > 0
      c = Curl.post("http://#{ENV['AIRGRAM_KEY']}:#{ENV['AIRGRAM_SECRET']}@api.airgramapp.com/1/broadcast", {
        :msg => "#{total_created} new articles for review"
      })
    end
  rescue Exception => e
    puts 'Problem sending Airgram notification: ' + e.message
  end

  out.join('<br>')
end