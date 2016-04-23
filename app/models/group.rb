class Group < ActiveRecord::Base

	acts_as_followable
	belongs_to :user
end
