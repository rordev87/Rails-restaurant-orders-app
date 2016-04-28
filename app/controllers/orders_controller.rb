class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

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
    if @email!=""
    # puts "***********************" + @email + "*****************************"
     @user = User.find_by_email(@email)
     @order = Order.find(params[:id])


     # if current_user.following?(@user)
        if current_user.following?(@user)
      unless OrderUserJoin.exists?(:user_id => @user.id) && OrderUserJoin.exists?(:order_id => @order.id) || current_user == @user.id
          @orderuserjoin = OrderUserJoin.new(
          order_id: @order.id,
          user_id: @user.id )
          @orderuserjoin.save
       end 
     end
                redirect_to order_path(@order.id)

        # UserGroup.new(user_id: @user.id , group_id:@group.id)
        #  flash[:notice] = "Successfully created post."
          #redirect_to orders_path
        #else
        #  render action: 'index'
        #end
        #redirect_to groups_path
      # end
   else
    redirect_to users_path {"error "}
    end
  end
  # GET /orders/new
  def new
    @order = current_user.orders.build
    #@meal = @order.meal
    #@restaurant = @order.restaurant

    # Git
    @users =User.all
    @groups =Group.all

  end

  # GET /orders/1/edit
  def edit
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
  def create
#<<<<<<< HEAD
    @order = current_user.orders.build(order_params)
    @order.meal = params[:meal]
    @order.status = "Waiting"
    @order.user_id = current_user.id
    @restaurant = @order.restaurant


#=======
#    @order = Order.new(order_params)
#    #puts params
#    @order.meal = params[:meal]
#    @order.status = "waiting"
#    @order.user_id = current_user.id
#>>>>>>> d922137f601ec6520049b8246b81626000fc5806
    respond_to do |format|
      if @order.save
        @orderUser=OrderUserJoin.new
        @orderUser.order_id=@order.id
        @orderUser.user_id=User.where(name: params["friend"]).take.id
        @orderUser.is_joined=0
        @orderUser.save
        create_notification("#{current_user.name} has invited you to his order",@orderUser.user_id,current_user.id,@order.id)
        puts "hellllllllllllllllllllllllllo"+@order.id.to_s+"and again"+User.where(name: params["friend"]).take.id.to_s
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

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
