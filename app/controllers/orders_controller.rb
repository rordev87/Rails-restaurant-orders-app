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
    @item=Item.new
    @invitedFriends=Array.new
    @joinedFriends=Array.new
    OrderUserJoin.where(:order_id => params[:id]).each do |orderuser|
      @user=User.find(orderuser.user_id)
      @invitedFriends.push(@user)
      if(orderuser.is_joined == 1)
        @joinedFriends.push(@user)
      end
    end
    @orderuserjoin = OrderUserJoin.all
  end


  def new_member
    @email = params[:user][:email]
    if @email!=""
    # puts "***********************" + @email + "*****************************"
     @user = User.find_by_email(@email)
     @order = Order.find(params[:id])


     # if current_user.following?(@user)
        @orderuserjoin = OrderUserJoin.new(
        order_id = @order.id,
        user_id = @user.id )
        @orderuserjoin.save

        # UserGroup.new(user_id: @user.id , group_id:@group.id)
        #  flash[:notice] = "Successfully created post."
          redirect_to orders_path
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
    @order=Order.find(params[:order_id])
    @orderUser=OrderUserJoin.where(:order_id => params[:order_id]).where(:user_id => params[:user_id]).take
    @orderUser.update("is_joined" => 1)
    #create_notification( "<a rel='nofollow' data-method='put' href='/orders/#{params[:order_id]}/#{params[:user_id]}'>Join</a>" , reciever_id = @order.user_id ,sender_id = params[:user_id] )
    redirect_to @order
  end

  def removeUser
    @order=Order.find(params[:order_id])
    OrderUserJoin.where(:order_id => params[:order_id]).where(:user_id => params[:user_id]).take.destroy
    
    redirect_to @order
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_user.orders.build(order_params)
    @order.user_id = current_user.id
    meal = @order.meal
    #@restaurant = @order.restaurant


    respond_to do |format|
      if @order.save
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
      params.require(:order).permit(:meal, :restaurant, :status, :user_id)
    end
end
