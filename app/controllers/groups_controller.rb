class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json
  
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
     @groups = Group.all
     @groupm = current_user.groups.build
    @usergroup=UserGroup.all
    @users=User.all

  end


  def show_users
    #todo make it for for the group only
    
    @usersIds= UserGroup.where(group_id: params[:id]).map { |e| e.user_id }
    #@usersIds = User.all.map{|u| u.id}
    respond_with User.where(id: @usersIds)

  end

  # GET /groups/new
  def new_member
    @email = params[:user][:email]
    @group = Group.find(params[:id])
    if @email !=""
   # puts "***********************" + @email + "*****************************"
     @user = User.find_by_email(@email)
       # puts "***********************" + @group + "*****************************"
      if @user != nil
       if current_user != @user.id
         if current_user.following?(@user)
            @userfound = UserGroup.where(:user_id => @user.id , :group_id => @group.id )
            if @userfound.exists? == false 
                @usergroup = UserGroup.new(
                group_id: @group.id,
                user_id: @user.id )
                @usergroup.save
                #  ' Add Frined to Group was successfully created.' 
                 
                redirect_to  group_path(@group.id)
            else 
                  puts '*********************** Frined aready founded .' 
                  redirect_to  group_path(@group.id)
            end 
         else 
           puts '******************* a user not a friend.' 
            redirect_to  group_path(@group.id)
         end
       else 
         puts '******************* trying to add himself to group .' 
          redirect_to  group_path(@group.id)
       end
     else
      puts '******************* not user'
      redirect_to  group_path(@group.id)    
     end
   else
    puts '*******************  email is empty.' 
    redirect_to group_path(@group.id)
 end 

end

  # GET /groups/1/edit
  def delete_member
    @usergroup = UserGroup.find(params[:id])
    @usergroup.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group member was successfully destroyed.' }
      format.json { head :no_content }
    end

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
      @group = Group.where(id: params[:id]).take
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name)
    end
end
