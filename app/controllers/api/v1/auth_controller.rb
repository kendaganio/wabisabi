module Api
  module V1
    class AuthController < ActionController::API
      def create
        user = User.find_by(email: user_params[:email])

        if user && user.valid_password?(user_params[:password])
          render json: {
            token: 'token'
          }
        else
          render json: {
            token: nil
          }, status: 401
        end
      end

      def user_params
        params.permit(:email, :password)
      end

    end
  end
end
