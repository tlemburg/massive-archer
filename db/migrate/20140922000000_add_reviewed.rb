class AddReviewed < ActiveRecord::Migration
    def up
        add_column :news_items, :reviewed, :boolean
        NewsItem.reset_column_information
        NewsItem.all.each do |item|
            item.reviewed = false
            item.save
        end
    end

    def down
        remove_column :news_items, :reviewed
    end
end