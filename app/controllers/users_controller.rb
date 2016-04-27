class UsersController < ApplicationController
  before_filter :authenticate_user!
  # GET /users
  # GET /users.json
  def index
    @users = User.all
   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end


  def newfollow
    @email = params[:user][:email]
    puts "***********************" + @email.inspect + "*****************************"
    # Rails.logg

    if @email!=""
    # puts "***********************" + @email + "*****************************"
     @user = User.find_by_email(@email)
      current_user.follow(@user)
     redirect_to users_path
   else
    redirect_to users_path {"error "}
    end


  end
  

  def follow
    unless current_user.id == params[:id]
    @user = User.find(params[:id])
    current_user.follow(@user)
    respond_to do |format|
      format.js {render :action=>"follow"}
    end
   end

  end


  def unfollow
    @user = User.find(params[:id])
    current_user.stop_following(@user)
    respond_to do |format|
      format.js {render :action=>"unfollow"}
  end

 end

end