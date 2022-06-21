class ApplicationController < ActionController::Base
  protected

  def redirect_if_logged_in
    if session[:user_id]
      redirect_to home_path
    end
  end

  def current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def require_login
    if session[:user_id] == nil
      redirect_to login_path
      return
    end

    current_user
  end
end
