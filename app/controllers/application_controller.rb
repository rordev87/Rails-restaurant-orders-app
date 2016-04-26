class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
    # before_action :authenticate_user!

    before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  def create_notification( message , reciever_id = nil,sender_id = nil )
  	Notification.create(:message => message, :reciever_id => reciever_id , :sender_id => sender_id   )

  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

end
