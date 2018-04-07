module Api
  module V1
    class PingController < BaseController
      def index
        render json: { pong: 'pong' }
      end
    end
  end
end
