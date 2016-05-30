require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class AuthEngine < OmniAuth::Strategies::OAuth2

      option :name, 'auth_engine'

      CUSTOM_PROVIDER_URL = ENV['AUTH_PROVIDER_URL']
      CUSTOM_PROVIDER_ME_URL = ENV['AUTH_PROVIDER_ME_URL'] || "/oauth/me.json"

      option :client_options, {
        site: CUSTOM_PROVIDER_URL,
        authorize_path: "#{CUSTOM_PROVIDER_URL}/oauth/authorize",
        access_token_path: "#{CUSTOM_PROVIDER_URL}/oauth/token"
      }

      uid {
        raw_user_info['id']
      }

      info do
        {
          email: raw_user_info['email'],
          admin: raw_user_info['admin']
        }
      end

      extra do
        {
          raw_user_info: raw_user_info
        }
      end

      def raw_user_info
        @raw_user_info ||= access_token.get(CUSTOM_PROVIDER_ME_URL).parsed
      end
    end
  end
end
