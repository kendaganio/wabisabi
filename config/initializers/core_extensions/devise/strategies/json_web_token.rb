module Devise
  module Strategies
    class JsonWebToken < Base
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        return fail! unless claims&.has_key?('user_id')

        success! User.find(claims['user_id'])
      end

      protected

      def claims
        strategy, token = request.headers['Authorization'].split(' ')
        return nil if (strategy || '').casecmp('bearer') != 0

        decoded = Auth::JWTDecode.call(token)
        decoded.first
      rescue JWT::DecodeError
        nil
      end
    end
  end
end
