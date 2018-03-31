module Api
  module V1
    class TasksController < ActionController::API
      before_action :authenticate_user!

      def create
        task = Task.new(task_params)
        if task.save
          render json: task.attributes
        else
          render json: {
            errors: task.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def show
        task = Task.find(params[:id])
        render json: task.attributes
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['not found'] }, status: :not_found
      end

      def task_params
        params.permit(:description)
      end
    end
  end
end
