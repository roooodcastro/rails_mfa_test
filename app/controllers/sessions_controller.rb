class SessionsController < ApplicationController
  def new; end

  def new_mfa
    user = User.find_by(name: user_params[:name])
    if user && user.authenticate(user_params[:password])
      session[:user_id] = user.id
      session[:mfa_authenticated] = !user.has_mfa?
      redirect_to root_path unless user.has_mfa?
    else
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

  def create
    user = User.find(session[:user_id])
    if user && user.authenticate_mfa(params[:token])
      session[:mfa_authenticated] = true
      return redirect_to root_path
    end
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
end
