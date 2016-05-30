class AuthEngine::UserSessionsController < AuthEngine::ApplicationController

  def create
    omniauth = env['omniauth.auth']

    user = User.find_or_create_by_id(id: omniauth['uid'])

    if user.respond_to?(:email)
      user.email = omniauth['info']['email']
    end

    user.save

    session[:user_id] = user.id

    redirect_to request.env['omniauth.origin'] || root_path
  end

  # Omniaytg failure callback
  def failure
    flash[:notice] = params[:message]
    redirect_to root_path
  end

  # logout - Clear our rack session BUT essentially redirect to the provider
  # to clean up the Devise session from there too !
  def destroy
    reset_session
    flash[:notice] = 'You have successfully signed out!'
    redirect_to "#{ENV['AUTH_PROVIDER_URL']}/users/sign_out"
  end
end
