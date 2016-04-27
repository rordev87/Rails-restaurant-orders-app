class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :message
      t.integer :sender_id 
      t.integer :reciever_id

      t.timestamps null: false
    end
  end
end
