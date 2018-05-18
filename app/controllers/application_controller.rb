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
end
