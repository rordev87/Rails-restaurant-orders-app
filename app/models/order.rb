class Order < ActiveRecord::Base

#	has_and_belongs_to_many :users
	acts_as_followable
	belongs_to :admin, class_name: :User, foreign_key: :user_id
	has_many :order_user_joins
	has_many :users, through: :order_user_joins, dependent: :destroy
	has_many :items, dependent: :destroy

	has_attached_file :image, styles: { medium: "300x300>"}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
