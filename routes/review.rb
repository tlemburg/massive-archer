before '/review*' do
  unless !@user.nil? && @user.is_admin
    puts 'unauthorized'
    redirect '/'
  end
end

get '/review' do
  # get all the news items that need review
  items_for_review = NewsItem.where(:reviewed => false, :user_reviewing => [nil, @user.id]).all

  # render a page with links to each
  erb :review, :locals => {:items => items_for_review}
end

get '/review/new' do
  erb :new_item
end

get '/review/:id' do
  # check that it is not under review
  item = NewsItem.find(params[:id])
  unless (item.user_reviewing.nil? || item.user_reviewing == @user.id)
    puts "already under review by user #{item.user_reviewing}"
    redirect '/review'
  end

  item.user_reviewing = @user.id
  item.save
  erb :review_item, :locals => {:item => item}
end

post '/review/new' do
  if params[:site_markdown] == ''
    redirect '/review/new'
  end

  item = NewsItem.create(
    :feed => 'ORIGINAL',
    :reviewed => true,
    :site_publish_date => Time.now,
    :site_markdown => params[:site_markdown]
  )

  redirect '/'
end

post '/review/:id' do
  # update the item with the appropriate info!
  item = NewsItem.find(params[:id])

  item.reviewed = true
  item.user_reviewing = nil
  if params[:approval] == 'approve'
    item.site_markdown = params[:site_markdown]
  end
  item.site_publish_date = Time.now

  item.save

  redirect '/review'
end

get '/review/:id/pass' do
  item = NewsItem.find(params[:id])
  item.user_reviewing = nil
  item.save

  redirect '/review'
end
