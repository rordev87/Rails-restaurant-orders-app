class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
  	#
  	#before_filter :signed_in_user, only: [:edit, :update]
  end
end
