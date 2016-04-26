class NotificationsController < ApplicationController
  include Entangled::Controller

  def index
    broadcast do
      @notifications = Notification.where(reciever_id: params[:user_id])
    end
  end

  def html_index
      @notifications = Notification.where(reciever_id: params[:id])
  end

  def create
    broadcast do
      #@child = Notification.new(child_params)
      #@child.parent_id = params[:parent_id]
      #@child.save
    end
  end

  def show
    broadcast do
      @notification = Notification.find(params[:id])
    end

  end
  def show
    broadcast do
      @notification = Notification.find(params[:id])
      @notification.update(:is_read => true)
    end

  end



end
