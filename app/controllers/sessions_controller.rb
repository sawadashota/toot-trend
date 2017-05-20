class SessionsController < ApplicationController
  include Session

  before_action :redirect_if_auth, except: :destroy

  def new
    @admin = Admin.new
  end

  def create
    admin = Admin.where(email: session_params[:email]).first
    if admin && session_params[:password] == Admin.decrypt(admin.password)
      log_in admin
      redirect_to admin_path
    else
      @admin = Admin.new
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end

  private

  def session_params
    params.require(:admin).permit(:email, :password)
  end

end
