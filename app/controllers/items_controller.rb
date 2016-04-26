class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /items
  # GET /items.json
  def index
    @order = Order.find(params[:id])
    @items = @order.items
    #@items = Item.all.paginate(:page => params[:page], :per_page => 5)
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.user_id=current_user.id
    @item.order_id=params[:order_id]
    respond_to do |format|
      @item.save
      format.html { redirect_to  order_path(params[:order_id]), notice: 'Item was successfully created.' }
      
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy

    @order = Order.find(params[:order_id])
    #@comment = @post.comments.find(params[:id])
    if @order.user_id.to_i == current_user.id.to_i  || @item.user_id.to_i == current_user.id.to_i
      @item.destroy
      respond_to do |format|
        format.html { redirect_to @order, notice: 'Item was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to post_path(@order)
      #render 'posts/show'
    end

    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :quantity, :price, :comment)
    end
end
