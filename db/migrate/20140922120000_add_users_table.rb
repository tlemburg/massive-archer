class AddUsersTable < ActiveRecord::Migration
    def up
        create_table :users do |t|
            t.string :username
            t.string :password_hash
            t.boolean :is_admin
            t.boolean :is_reviewer
            t.boolean :subscription_valid
            t.string :stripe_customer_id
        end

        User.reset_column_information
        User.create(
            :username => 'tyler',
            :password_hash => '$2a$10$nfILnF6aInrEGs5NvsQwiuKEuDttG7udtdRkSnQnF4nhwoaC63mS2',
            :is_admin => true,
            :is_reviewer => true,
            :subscription_valid => false,
            :stripe_customer_id => nil,
        )

        User.create(
            :username => 'tim',
            :password_hash => '$2a$10$sxp6gHdLQJ7ivwsxxyM4cO3SsoQh4SSEHy1zkexpM7uJiz7HnHbCm',
            :is_admin => true,
            :is_reviewer => true,
            :subscription_valid => false,
            :stripe_customer_id => nil,
        )
    end
end