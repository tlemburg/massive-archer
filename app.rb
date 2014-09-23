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

get '/' do
    news_items = NewsItem.where(:reviewed => true).where.not(:site_markdown => nil).order(:site_publish_date => :desc).limit(10).all
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    news_items = news_items.map do |item|
        markdown.render(item.site_markdown.sub('item_link', item.link))
    end.join

	erb :index, :locals => {:recent_items_html => news_items}
end

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

get '/scan' do
  out = []

  # get the list of RSS feeds
  feeds = {
    'OWH' => 'http://www.omaha.com/search/?q=&t=article&l=25&d=&d1=&d2=&s=start_time&sd=desc&c[]=huskers/football*&f=rss',
    'HUSKERS' => 'http://www.huskers.com/rss.dbml?db_oem_id=100&RSS_SPORT_ID=22&media=news',
    'ESPN' => 'http://espn.go.com/blog/feed?blog=collegesnebraska'
  }

  feeds.each do |name, url|
    begin
        open(url) do |rss|
            feed = RSS::Parser.parse(rss, false)

            feed.items.each do |item|
                guid = item.guid.content
                if NewsItem.where(:guid => guid, :feed => name).first.nil?
                    new_item = NewsItem.create(
                        :title => item.title,
                        :guid => guid,
                        :link => item.link,
                        :feed => name,
                        :reviewed => false,
                        :original_publish_date => item.pubDate
                    )
                    out << "Inserted #{name} article with title:  #{item.title}"
                else 
                    out << "Skipped #{name} article with title:  #{item.title}"
                end
            end
        end
    rescue
        out << "Error with #{name} feed, did not read"
    end
  end

  out.join('<br>')
end

get '/review' do
    # get all the news items that need review
    items_for_review = NewsItem.where(:reviewed => false).all

    # render a page with links to each
    erb :review, :locals => {:items => items_for_review}
end

get '/review/:id' do
    item = NewsItem.find(params[:id])

    erb :review_item, :locals => {:item => item}
end

post '/review/:id' do
    # update the item with the appropriate info!
    item = NewsItem.find(params[:id])

    item.reviewed = true
    if params[:approval] == 'approve'
        item.site_markdown = params[:site_markdown]
    end
    item.site_publish_date = Time.now

    item.save

    redirect '/review'
end
