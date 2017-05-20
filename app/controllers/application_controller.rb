class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def redirect_if_auth
    redirect_to admin_path if log_in?
  end

  def redirect_unless_auth
    redirect_to login_path unless log_in?
  end

  def current_admin
    @current_admin ||= Admin.where(email: session[:admin_email]).first
  end

  def log_in?
    !current_admin.nil?
  end

  def log_in(admin)
    session[:admin_email] = admin.email
  end

end
