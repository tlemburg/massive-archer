get '/' do
    news_items = NewsItem.where(:reviewed => true).where.not(:site_markdown => nil).order(:site_publish_date => :desc).limit(10).all
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    news_items = news_items.map do |item|
        markdown.render(item.site_markdown.sub('item_link', item.link || ''))
    end.join

    erb :index, :locals => {:recent_items_html => news_items}
end