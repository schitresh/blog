class UsersController < ApplicationController
  before_action :find_user, only: %w[edit update show destroy]
  before_action :require_same_user, only: %w[edit update destroy]
  before_action :require_admin, only: %w[destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome Welcome"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Account updated successfully."
    else
      render 'edit'
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user.destroy
    flash[:danger] = "User and all its articles are deleted."
    redirect_to users_path
  end

  private
  
  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "Unauthorized action."
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Admin required."
      redirect_to root_path
    end
  end
end