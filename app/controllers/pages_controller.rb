class PagesController < ApplicationController
	before_action :authenticate_user!
	def index
		@orders = Order.where(user_id: current_user.id.to_i).last(3).reverse
	end

end
