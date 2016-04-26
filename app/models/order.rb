class Order < ActiveRecord::Base
	belongs_to :admin , :class_name => :User , :foreign_key => :user_id
	#has_many :users ,:through => :user_orders
#	has_and_belongs_to_many :users
    has_many :order_user_joins
	has_many :items

end
