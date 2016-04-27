class Group < ActiveRecord::Base

	acts_as_followable
	belongs_to :user
	has_many :user_groups
	has_many :users, through: :user_groups
end
