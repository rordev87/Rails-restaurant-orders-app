class CreateOrderUserTable < ActiveRecord::Migration
  def change
    create_table :orders_users , :id => false do |t|
    	t.integer "user_id"
    	t.integer "order_id"

    	
    end
  end
end
