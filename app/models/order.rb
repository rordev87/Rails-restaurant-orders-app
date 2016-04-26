class Order < ActiveRecord::Base
	belongs_to :admin , :class_name => :User , :foreign_key => :admin_id
	has_many :users ,:through => :orders_users
	has_many :orders_users
	has_many :items

end
