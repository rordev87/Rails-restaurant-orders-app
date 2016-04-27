class HomeController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :json
  def getorderbyuser
    @orders_of_me = OrderUserJoin.where(user_id: current_user.id).order(:created_at => :desc).limit(5).map{|m| Order.find(m.order_id)} + Order.where(:user_id => current_user.id).map{|o| o};
    @orders_of_me = @orders_of_me.uniq.sort{|a,b| b.created_at <=> a.created_at }[0..4] 
    #@orders_of_me = OrderUserJoin.all.map{|m| Order.find(m.order_id)};
    respond_with(@orders_of_me)

    #respond_to do |format|
    #  format.json @orders_of_me.to_json 
    #end


  end




  def getuser
    @user = User.find(params[:id]); 
    respond_with(@user)

  end


  def getorderbyfriends
    #friends_ids=current_user.follows.map{|u| u.id};
    friends_ids=current_user.follows.map{|u| u.followable_id}
    #friends_ids= User.all.map{ |u| u.id} 
    #@orders_of_friends_joined = OrderUserJoin.where(user_id: friends_ids).order(:created_at => :desc).limit(5).map{ |m| Order.find(:order => m.order_id , :admin => )} 
    @orders_of_friends = Order.where( user_id: friends_ids).order(:created_at => :desc).limit(5).map{ |o| {:admin => User.find(o.user_id) , :order => o } }
    #
    #@orders_of_friends = @orders_of_friends.uniq.sort{|a,b| b.created_at <=> a.created_at }[0..4] 
    
    #.each{|u| u.user_id = User.find(u.user_id) } #.map{ |m| Order.find(m.order_id) };
    #@order_of_friends
    #@order_of_friends.map{ |o| {:admin => User.find(o.user_id) , :order => o } }
    respond_with(@orders_of_friends)
#   	respond_to do |format|
#      		format.json {}
      		#format.json @orders_of_friends.to_json 

#    	end
   

  end


  def index
  	#
  	#before_filter :signed_in_user, only: [:edit, :update]
  end
end
