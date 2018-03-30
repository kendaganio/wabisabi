module Api
  module V1
    class AuthController < ActionController::API
      def create
        user = User.find_by(email: user_params[:email])

        if user&.valid_password?(user_params[:password])
          render json: { token: Auth::JWTEncode.call(user_id: user.id) }
        else
          render json: {
            token: nil,
            error: I18n.t('auth.invalid_credentials')
          }, status: 403
        end
      end

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
