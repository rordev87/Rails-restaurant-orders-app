class AddOrderIdToNotifcation < ActiveRecord::Migration
  def change
    add_column :notifications, :order_id, :integer , null: false
  end
end
