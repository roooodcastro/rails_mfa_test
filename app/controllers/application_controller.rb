class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_on?

  def current_user
    return nil unless logged_on?
    @current_user ||= User.find(session[:user_id])
  end

  def logged_on?
    session[:user_id] && session[:mfa_authenticated]
  end

  private

  # Can be used with "before_action" as a crude authorization feature, where
  # it will redirect to the login page is the user tries to access an action
  # without being logged on.
  def login_required
    return if logged_on?
    flash[:error] = 'This action requires login'
    redirect_to new_session_path
  end
end
