class UsersController < ApplicationController
  
  before_filter :can_edit_user, :only => [:edit, :update, :destroy, :confirm_delete]
  
  filter_parameter_logging "password"
  
  def index
    @users = User.find(:all, :order => 'profile_updated_at desc', :conditions => 'id != 1') # hide guest user
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    render :action => :new and return unless @user.save
    flash[:notice] = "The new user has been created."
    if logged_in?
      redirect_to users_path and return
    else
      do_login(@user)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.profile_updated_at = Time.now.utc
    @user.save!
    redirect_to user_path(@user)
  end
  
  def destroy
    @user = User.find(params[:id])
    if params[:confirm] != "1"
      flash[:notice] = "You must check the confirmation box"
      redirect_to confirm_delete_user_path(@user)
    else
      @user.destroy
      redirect_to users_path
    end
  end
  
  def confirm_delete
  end
  
  def login
    redirect_to home_path if logged_in?
    if request.post?
      @user = User.authenticate(params[:user][:login], params[:user][:password]) 
      if @user
        do_login(@user)
      else
        flash[:notice] = "Invalid user/password combination"
        render :action => :login
      end
    end
  end
  
  def logout
    @flash = flash[:notice]
    reset_online_at
    reset_session
    flash[:notice] = @flash
    redirect_to home_path
  end
    
  protected
  
  def can_edit_user
    @user = User.find(params[:id])
    redirect_to user_path(@user) and return false unless admin? || (current_user == @user)
  end
  
  def do_login(user)
    session[:user_id] = user.id
    session[:last_session_at] = user.last_login_at
    user.last_login_at = Time.now.utc
    user.save!
    redirect_to home_path
  end
  
end
