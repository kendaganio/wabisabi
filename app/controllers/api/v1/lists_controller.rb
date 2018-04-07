module Api
  module V1
    class ListsController < BaseController
      def index
        render json: ListSerializer.new(current_user.lists)
      end

      def create
        list = current_user.lists.new(list_params)
        if list.save
          render json: ListSerializer.new(list)
        else
          render unprocessable_entity(list.errors.full_messages)
        end
      end

      def show
        render json: {}
      end

      def destroy
        render json: {}
      end

      private

      def list_params
        params.permit(:name)
      end
    end
  end
end
