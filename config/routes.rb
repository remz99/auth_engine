Rails.application.routes.draw do

  # omniauth
  get '/auth/:provider/callback', :to => 'auth_engine/user_sessions#create'
  get '/auth/failure', :to => 'auth_engine/user_sessions#failure'

  # Custom logout
  post '/logout', :to => 'auth_engine/user_sessions#destroy'

end
