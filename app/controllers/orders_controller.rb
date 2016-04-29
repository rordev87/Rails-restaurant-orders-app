class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  arr = Array.new
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.where(user_id: current_user.id.to_i).paginate(:page => params[:page], :per_page => 5)
  end


  # GET /orders/1
  # GET /orders/1.json
  def show
    @order=Order.where(id: params[:id]).take
    if ( (isInvited @order.id, current_user.id) || @order.user_id == current_user.id)
      @order=Order.where(id: params[:id]).take
      @item=Item.new
      @isJoined = (isJoined @order.id, current_user.id) || @order.user_id == current_user.id
      @invitedFriends=Array.new
      @joinedFriends=Array.new
      OrderUserJoin.where(:order_id => params[:id]).each do |orderUser|
        @user=User.find(orderUser.user_id)
        @invitedFriends.push(@user)
        if(orderUser.is_joined == 1)
          @joinedFriends.push(@user)
        end
      end
      @orderuserjoin = OrderUserJoin.all
      @users = User.all
    else
      redirect_to orders_path 
    end
  end

  def isInvited order_id, user_id
    OrderUserJoin.where(:order_id => order_id).where(:user_id => user_id).take 
  end

  def isJoined order_id, user_id
    OrderUserJoin.where(:order_id => order_id).where(:user_id => user_id).where(:is_joined => 1).take 
  end


  def new_member
    @email = params[:user][:email]
    @order = Order.find(params[:id])
    if @email !=""
   # puts "***********************" + @email + "*****************************"
     @user = User.find_by_email(@email)
       # puts "***********************" + @group + "*****************************"
      if @user != nil
       if current_user != @user.id
         if current_user.following?(@user)
            puts '************************************ Friend found'
            @userfound = OrderUserJoin.where(:user_id => @user.id , :order_id => @order.id )
            if @userfound.exists? == false 
                @orderuserjoin = OrderUserJoin.new(
                order_id: @order.id,
                user_id: @user.id )
                @orderuserjoin.save
                #  ' Add Frined to Group was successfully created.' 
                 
                redirect_to  order_path(@order.id)
            else 
                  puts '*********************** Frined aready founded .' 
                  redirect_to  order_path(@order.id)
            end 
         else 
           puts '******************* a user not a friend.' 
            redirect_to  order_path(@order.id)
         end
       else 
         puts '******************* trying to add himself to group .' 
          redirect_to  order_path(@order.id)
       end
     else
      puts '******************* not user'
      redirect_to  order_path(@order.id)    
     end
   else
    puts '*******************  email is empty.' 
    redirect_to order_path(@order.id)
 end 
  end
  # GET /orders/new
  def new
    @order = current_user.orders.build


    @friends_id = current_user.follows.map{|u| u.followable_id} 
    @friends = @friends_id.map{|u| User.find(u)}#current_user.follows.map{|u| User.find(u.followable_id)}
    u_group_ids = UserGroup.where(:user_id => current_user.id).map{|ug| ug.order_id}
    @groups = Group.where(user_id: current_user.id);

  end

  def create
    @order = Order.new(order_params)
    @order.meal = params[:meal]
    @order.status = "waiting"
    @order.user_id = current_user.id
    @restaurant = @order.restaurant

    puts "loooooooooooooooooooooooooooooooooooooooooooooo"+params[:firendsToBeAdded].to_s
    respond_to do |format|
      if @order.save
        puts params["firendsToBeAdded"]
        @friendsInvited = params[:firendsToBeAdded].split(",").map{|m| m.to_i}.each do |friendId|
          @orderUser=OrderUserJoin.new
          @orderUser.order_id=@order.id
          @orderUser.user_id=friendId
          @orderUser.is_joined=0
          @orderUser.save
          create_notification("#{current_user.name} has invited you to his order",friendId,current_user.id,@order.id)
        end
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end




  def joinOrder
    @order=Order.where(id: params[:order_id]).take
    @orderUser=OrderUserJoin.where(:order_id => params[:order_id]).where(:user_id => params[:user_id]).take
    @orderUser.update("is_joined" => 1)
    #create_notification( "<a rel='nofollow' data-method='put' href='/orders/#{params[:order_id]}/#{params[:user_id]}'>Join</a>" , reciever_id = @order.user_id ,sender_id = params[:user_id] )
    create_notification("#{current_user.name} has joined your order",@order.user_id,current_user.id,@order.id)
    redirect_to @order
  end

  def removeUser
    @order=Order.where(id: params[:order_id]).take
    OrderUserJoin.where(:order_id => params[:order_id]).where(:user_id => params[:user_id]).take.destroy
    
    redirect_to @order
  end

  # POST /orders
  # POST /orders.json
  
  
  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    
    respond_to do |format|
      if @order.update("status" => "finished")
        format.html { redirect_to orders_url, notice: 'Order was successfully updated.' }
        format.json { render :index, status: :ok, location: @order }
      else
        format.html { render :index }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:meal, :restaurant, :image )
    end
end
