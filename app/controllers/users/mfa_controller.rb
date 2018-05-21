class Users::MfaController < ApplicationController
  before_action :set_user

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
end
