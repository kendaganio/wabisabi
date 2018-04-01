module Api
  module V1
    class BaseController < ActionController::API
      private

      def not_found(errors = nil)
        errors ||= [I18n.t('api.not_found')]
        render json: {
          errors: [I18n.t('api.not_found')]
        }, status: :not_found
      end

      def unprocessable_entity(errors = nil)
        errors ||= [I18n.t('api.unprocessable_entity')]
        render json: {
          errors: errors
        }, status: :unprocessable_entity
      end
    end
  end
end
