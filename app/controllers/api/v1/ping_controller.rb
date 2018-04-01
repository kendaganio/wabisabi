module Api
  module V1
    class PingController < BaseController
      before_action :authenticate_user!

      def index
        render json: { pong: 'pong' }
      end
    end
  end
end
