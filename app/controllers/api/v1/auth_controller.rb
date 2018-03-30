module Api
  module V1
    class AuthController < ActionController::API
      def create
        render json: {
          token: 'token'
        }
      end
    end
  end
end
