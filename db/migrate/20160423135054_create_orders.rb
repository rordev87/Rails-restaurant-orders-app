class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :meal
      t.string :restaurant
      t.string :status
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
