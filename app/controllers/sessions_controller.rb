class SessionsController < ApplicationController
  def new; end

  def new_mfa
    @user = User.find_by(name: user_params[:name])
    return login_and_redirect if @user&.authenticate(user_params[:password])
    flash.alert = 'Email or password is invalid'
    redirect_to new_session_path
  end

  def create
    @user = User.find(session[:user_id])
    return redirect_after_2fa if @user&.authenticate_mfa(params[:token])
    flash.now.alert = 'MFA token is invalid'
    render :new_mfa
  end

  def destroy
    reset_session
    flash[:notice] = 'You are now logged out!'
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end

  # Logs the user in and redirects to the root_path, if it doesn't use 2FA.
  # If it does, just let the "new_mfa" template be rendered so the user can
  # enter his 2FA token.
  def login_and_redirect
    session[:user_id] = @user.id
    session[:mfa_authenticated] = !@user.mfa?
    redirect_to root_path unless @user.mfa?
  end

  # Sets the mfa_authenticated attribute in the session to true, and redirect
  # the user to the root_path
  def redirect_after_2fa
    session[:mfa_authenticated] = true
    flash[:notice] = 'You are now logged in!'
    redirect_to root_path
  end
end
