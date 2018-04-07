module Api
  module V1
    class TasksController < BaseController

      def index
        render json: TaskSerializer.new(current_user.tasks)
      end

      def create
        task = current_user.tasks.new(task_params)
        if task.save
          render json: TaskSerializer.new(task)
        else
          render unprocessable_entity(task.errors.full_messages)
        end
      end

      def show
        task = find_task
        render json: TaskSerializer.new(task)
      rescue ActiveRecord::RecordNotFound
        render not_found
      end

      def destroy
        task = find_task
        task.destroy

        render json: TaskSerializer.new(task)
      rescue ActiveRecord::RecordNotFound
        render not_found
      end

      private

      def task_params
        params.permit(:description)
      end

      def find_task
        current_user.tasks.find(params[:id])
      end
    end
  end
end
