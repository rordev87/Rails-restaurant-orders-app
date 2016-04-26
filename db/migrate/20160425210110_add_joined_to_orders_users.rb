class AddJoinedToOrdersUsers < ActiveRecord::Migration
  def change
  	add_column :orders_users, :is_joined, :integer
  end
end
