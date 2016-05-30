class AuthEngine::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :check_cookie

  helper_method :signed_in?, :current_user

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
    return nil unless session[:user_service_key]
    @current_user ||= User.find_by_user_service_key(session[:user_service_key])
  end

  def signed_in?
    current_user.present?
  end

  def check_cookie
    reset_session unless cookie_valid?
  end

  def cookie_valid?
    cookies[:auth_engine].present? &&
      session[:user_service_key].present? &&
      cookies[:auth_engine].to_s == session[:user_service_key].to_s
  end
end
