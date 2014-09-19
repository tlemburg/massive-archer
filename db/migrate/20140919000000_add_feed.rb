class AddFeed < ActiveRecord::Migration
    def change
        add_column :news_items, :feed, :string
    end
end