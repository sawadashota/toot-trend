module Session
  def log_out
    session.delete(:admin_email)
    @current_admin = nil
  end
end
