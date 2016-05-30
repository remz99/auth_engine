class AuthEngine::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def login_required
    not_authorized unless current_user
  end

  def not_authorized
    respond_to do |format|
      format.html { redirect_to "/auth/auth_engine?origin=#{request.original_url}" }
      format.json { head :unauthorized }
    end
  end

  def current_user
    return nil unless session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    current_user.present?
  end

  helper_method :signed_in?
  helper_method :current_user

  before_filter :check_cookie

  def check_cookie
    reset_session unless cookie_valid?
  end

  def cookie_valid?
    cookies[:auth_engine].present? &&
      session[:user_id].present? &&
      cookies[:auth_engine].to_s == session[:user_id].to_s
  end
end
