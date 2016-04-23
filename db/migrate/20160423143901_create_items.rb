class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :user_id
      t.integer :order_id
      t.integer :quantity
      t.decimal :price
      t.text :comment

      t.timestamps null: false
    end
  end
end
