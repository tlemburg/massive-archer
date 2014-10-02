class AddTempUsersTable < ActiveRecord::Migration
  def change
    create_table :temp_users do |t|
      t.datetime :valid_until
      t.string :key
    end
  end
end