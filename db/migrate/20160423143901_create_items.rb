class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :user_id
      t.references :order, index: true, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.text :comment

      t.timestamps null: false
    end
  end
end


