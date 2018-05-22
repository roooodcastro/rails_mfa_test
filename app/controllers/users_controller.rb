class UsersController < ApplicationController
  before_action :login_required, except: %i[index new create]
  before_action :set_user, only: %i[show edit update destroy]
  before_action :verify_same_user, only: %i[show edit update destroy]

  # GET /users
  def index
    @users = if current_user&.admin?
               User.all
             else
               User.where(id: session[:user_id])
             end
  end

  # GET /users/1
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      session[:mfa_authenticated] = true
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :password)
  end

  # Can only see and change its own user, except if it's admin
  def verify_same_user
    return if @user&.admin?
    redirect_to users_path unless @user&.id == session[:user_id]
  end
end
