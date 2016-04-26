class AddIsJoinedToOrderUserJoins < ActiveRecord::Migration
  def change
    add_column :order_user_joins, :is_joined, :integer
  end
end
