class UsersOrders < ActiveRecord::Migration
  def change
  	create_table :users_orders do |t|
  		t.integer :user_id
  		t.integer :order_id
  	end

  end
end
