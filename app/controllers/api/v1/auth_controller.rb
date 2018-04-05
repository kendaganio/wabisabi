module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_user!

      def create
        user = User.find_by(email: user_params[:email])

        if user&.valid_password?(user_params[:password])
          render json: { token: Auth::JWTEncode.call(user_id: user.id) }
        else
          render forbidden
        end
      end

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
