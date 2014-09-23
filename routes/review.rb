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