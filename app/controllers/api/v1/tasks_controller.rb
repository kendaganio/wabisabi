module Api
  module V1
    class TasksController < ActionController::API
      before_action :authenticate_user!

      def index
        render json: { tasks: current_user.tasks }
      end

      def create
        task = current_user.tasks.new(task_params)
        if task.save
          render json: task.attributes
        else
          render json: {
            errors: task.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def show
        task = find_task
        render json: task.attributes
      rescue ActiveRecord::RecordNotFound
        not_found
      end

      def destroy
        task = find_task
        task.destroy
        render json: task.attributes
      rescue ActiveRecord::RecordNotFound
        not_found
      end

      private
      def task_params
        params.permit(:description)
      end

      def find_task
        current_user.tasks.find(params[:id])
      end

      def not_found
        render json: { errors: ['not found'] }, status: :not_found
      end
    end
  end
end
