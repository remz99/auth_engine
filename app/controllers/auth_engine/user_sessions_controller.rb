class AuthEngine::UserSessionsController < AuthEngine::ApplicationController

  #
  # creates user records in the consumer applications
  #
  def create
    #request.env['omniauth.auth'] contains the Authentication Hash with all the data about a user.

    # <OmniAuth::AuthHash
    #  credentials=#<OmniAuth::AuthHash expires=true expires_at=1466038838 token="1c8a2ac55728364f9fce93fa005c0b4d3a6f56108790927d4586e5ec409a1dd8">
    #  extra=#<OmniAuth::AuthHash raw_user_info=#<OmniAuth::AuthHash admin=true city_id=nil created_at="2016-06-13T23:40:13.893Z" email="remyflatt@gmail.com" id=4 updated_at="2016-06-15T23:00:38.225Z" user_service_key=4>>
    #  info=#<OmniAuth::AuthHash::InfoHash admin=true email="remyflatt@gmail.com">
    #  provider="auth_engine"
    #  uid=4>

    omniauth = env['omniauth.auth']
    user_service_key = omniauth['uid'] #User’s unique identifier

    user = User.find_or_create_by(user_service_key: user_service_key)

    Rails.cache.write("/users/#{user.user_service_key}", omniauth)

    user.save

    # set session values
    session[:user_service_key] = user.user_service_key
    session[:access_token] = omniauth.credentials.token

    # get token info
    #  HTTParty.get('http://localhost:3000/oauth/token/info?access_token=1c8a2ac55728364f9fce93fa005c0b4d3a6f56108790927d4586e5ec409a1dd8')

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
