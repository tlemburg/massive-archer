class AddUserReviewing < ActiveRecord::Migration
  def change
    add_column :news_items, :user_reviewing, :integer
  end
end