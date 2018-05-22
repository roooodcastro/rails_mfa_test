class Users::MfaController < ApplicationController
  before_action :login_required
  before_action :set_user
  before_action :verify_same_user

  def create
    @user.generate_mfa_secret!
    flash[:notice] = '2FA credentials have been created for you!'
    redirect_to @user
  end

  def destroy
    @user.remove_mfa_secret!
    flash[:notice] = 'You are no longer using 2FA!'
    redirect_to @user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  # Can only see and change its own user, except if it's admin
  def verify_same_user
    return if @user&.admin?
    redirect_to users_path unless @user&.id == session[:user_id]
  end
end
