class CreateOrderUserJoins < ActiveRecord::Migration
  def change
    create_table :order_user_joins do |t|
      t.references :user
      t.references :order

      t.timestamps null: false
    end
  end
end
