class UsersController < ApplicationController
  before_filter :authorize, :except => ['login','new','create','log_user_in'] 
  #before_filter :validate_password, :only => ['edit','update','destroy'], :unless => is_admin?(User.find(params[:id])) 
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    begin
      @user_to_edit = User.find(params[:id]) #user whose information is to be edited
    rescue ActiveRecord::RecordNotFound
      logger.debug "Attempt to access invalid user with id '#{params[:id]}'"
      render_404 and return
    end

    @user = get_current_user                   #currently logged in user
    if authorized_to_edit_user?(@user,@user_to_edit) #if admin user or self then allow edit
			 render :layout => 'dashboard'
    else
       flash.keep[:warning] = "You are not authorized to edit this user. This action has been logged."
       ##Log action to database goes here.
       redirect_to dashboards_path
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash.keep[:success] = 'User was successfully Created.'
        flash.keep[:notice] = 'A confirmation email has been sent to your email box. Click on the confirmation link to complete registration.'
        format.html { redirect_to login_path }
        #format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        #format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash.keep[:success] = 'User was successfully updated.'
        format.html { redirect_to @user }
        format.json { head :no_content }
      else
        format.html { redirect_to action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
     flash.keep[:success] = 'User was successfully destroyed.'
     flash.keep[:warn] = 'You will not be able to login using the deleted account'
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  def login
				@user = User.new
		respond_to do |format|
      format.html {render action: "login" }
    end
  end
  def log_user_in
    @user = allocate_user_session(params[:user][:name],params[:user][:password])
    if @user
         flash.keep[:notice] = 'You have successfully logged in!'
         respond_to do |format|
           format.html {redirect_to dashboards_path }
         end
    else                                        
         flash.keep[:error] = 'Login unsuccessful. Try again with the correct username and password'
         respond_to do |format|         
						format.html {redirect_to login_path }
         end
    end
  end

  def log_user_out
    deallocate_user_session
    flash.keep[:notice] = 'You have successfully logged out!'
    respond_to do |format|         
				format.html {redirect_to login_path }
    end
  end
  
  private

  def authorized_to_edit_user?(current_user,user_to_edit_id)
      logger.debug "#{current_user.id == user_to_edit_id}"
      logger.debug "current_user.id = #{current_user.id} and user_to_edit_id = #{user_to_edit_id}"
      if (current_user == user_to_edit_id)
         return true
      elsif current_user.is_admin?
         return true
      else
         return false
      end
  end
end
