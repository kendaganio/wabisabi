module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_user!

      private

      def not_found(errors = nil)
        errors ||= [I18n.t('api.not_found')]
        { json: { errors: errors }, status: :not_found }
      end

      def unprocessable_entity(errors = nil)
        errors ||= [I18n.t('api.unprocessable_entity')]
        { json: { errors: errors }, status: :unprocessable_entity }
      end

      def forbidden(error = nil)
        error ||= I18n.t('auth.invalid_credentials')
        { json: { token: nil, error: error }, status: :forbidden }
      end
    end
  end
end
