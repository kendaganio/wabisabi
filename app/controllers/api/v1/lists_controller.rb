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
        list = find_list
        render json: ListSerializer.new(list)
      rescue ActiveRecord::RecordNotFound
        render not_found
      end

      def destroy
        list = find_list
        list.destroy

        render json: ListSerializer.new(list)
      rescue ActiveRecord::RecordNotFound
        render not_found
      end

      private

      def find_list
        current_user.lists.find(params[:id])
      end

      def list_params
        params.permit(:name)
      end
    end
  end
end
