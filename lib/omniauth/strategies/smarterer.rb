require 'omniauth-oauth2'
require "multi_json"
require "rest-client"

module OmniAuth
  module Strategies
    class Smarterer < OmniAuth::Strategies::OAuth2

      option :client_options, {
        site: 'https://smarterer.com/',
        authorize_url: 'https://smarterer.com/oauth/authorize',
        token_url: 'https://smarterer.com/oauth/access_token',
        token_method: :get
      }

      option :provider_ignores_state, true

      def request_phase
        super
      end

      def callback_phase
        super
      end

      uid { raw_info['username'].to_s }

      info do
        {
          username: raw_info['username'],
          first_name: raw_info['first_name'],
          last_name: raw_info['last_name'],
          full_name: "#{raw_info['first_name']} #{raw_info['last_name']}",
          bio: raw_info['bio'],
          image: raw_info['profile_image'],
          url: raw_info['link'],
          location: raw_info['location'],
          organization: raw_info['organization']
        }
      end

      extra do
        {raw_info: raw_info}
      end

      def raw_info
        if @raw_info.nil?
          @raw_info = {}
          params = {access_token: access_token.token}
          response = RestClient.get('https://smarterer.com/api/users/me', { :params => params })
          user = MultiJson.decode(response.to_s)
          @raw_info.merge!(user)
        end

        @raw_info
      end
    end
  end
end
