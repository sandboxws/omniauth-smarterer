require 'multi_xml'
require 'omniauth-oauth'
require 'oauth'

module OmniAuth
  module Strategies
    class Smarterer < OmniAuth::Strategies::OAuth
      option :client_options, {
        :site => 'http://smarterer.com',
        :authorize_url => 'https://smarterer.com/oauth/authorize',
        :token_url => 'https://smarterer.com/oauth/access_token'
      }

      def request_phase
        super
      end

      uid { raw_info['id'].to_s }

      info do
        {
          'name' => raw_info['name']
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        if @raw_info.nil?
        end

        @raw_info
      end
    end
  end
end
