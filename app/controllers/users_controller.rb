class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy] #stop people from accessing these pages unless they have signed in
    #before action rungs before every action controller so we use only to only apply to those that we need
  before_action :correct_user, only:[:edit, :update] # makes sure that the user iss the correct one
  before_action :admin_user, only: :destory

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user=User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile update"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    #Before filters

    def signed_in_user #this makes sure that you cannot access edit urls without being signed in
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end