class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
    @group = current_user.groups.build
    @usergroup=UserGroup.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @usergroup=UserGroup.all
    @users=User.all

  end

  # GET /groups/new
  def new_member
    @email = params[:user][:email]
    if @email!=""
    # puts "***********************" + @email + "*****************************"
     @user = User.find_by_email(@email)
     @group = Group.find(params[:id])

     # if current_user.following?(@user)
        @usergroup = UserGroup.new
        @usergroup.group_id = @group.id,
        @usergroup.user_id = @user.id 
        @usergroup.save

        # UserGroup.new(user_id: @user.id , group_id:@group.id)
        #  flash[:notice] = "Successfully created post."
          redirect_to groups_path
        #else
        #  render action: 'index'
        #end
        #redirect_to groups_path
      # end
   else
    redirect_to users_path {"error "}
    end
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = current_user.groups.build(group_params)
    @group.user_id = current_user.id

    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_path, notice: 'Group was successfully created.' }
        format.json { render :index, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name)
    end
end
