class NotificationsController < ApplicationController
  include Entangled::Controller

  def index
    broadcast do
      @notifications = Notification.where(reciever_id: params[:user_id])
    end
  end

  def create
    broadcast do
      #@child = Notification.new(child_params)
      #@child.parent_id = params[:parent_id]
      #@child.save
    end
  end


end
