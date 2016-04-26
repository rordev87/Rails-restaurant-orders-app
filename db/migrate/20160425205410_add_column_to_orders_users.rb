class AddColumnToOrdersUsers < ActiveRecord::Migration
  def change
  	add_column :orders_users, :order_id, :integer
    add_column :orders_users, :user_id, :integer
  end
end
