class CreateDb < ActiveRecord::Migration
	def change
		create_table :news_items do |t|
			t.string :title
			t.string :author
			t.string :guid
			t.string :link
			t.datetime :original_publish_date
			t.datetime :site_publish_date
			t.string :site_markdown
		end
	end

end
