class UsersController < ApplicationController

   before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy





  def index
    @users = User.paginate(page: params[:page])
  end


def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
end

  def new
    @user = User.new

  end

  def create
    @user = User.create(user_params)
    if @user
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit

  end

   def update
      if @user.update(user_params)  #Note the use of user_params in the call to update_attributes, which uses strong parameters to prevent mass assignment vulnerability
        flash.now[:success] = "Profile updated"
        render 'show'
      else
        render 'edit'
      end
   end



  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

  # Before filters
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end



    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
