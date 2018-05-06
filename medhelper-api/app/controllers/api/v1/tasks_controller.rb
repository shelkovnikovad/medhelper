module Api
  module V1
    class TasksController < ApplicationController
      before_action :authorize

      def index
        if is_current_user_operator
          @tasks = Task.order('created_at DESC').includes(:user)
        else
          @tasks = Task.where(status: false).order('created_at DESC').includes(:user)
        end

        render status: :ok
      end

      def show
        @task = Task.find(params[:id])
        if @task
          render status: :ok
        else
          render json: {task: "not found"}, status: :not_found
        end
      end

      def create
        task = Task.new(post_params)
        if task.save
          render json: nil, status: :created
        else
          render json: nil, status: :bad_request
        end
      end

      def update
        task = Task.find(params[:id])
        if task
          if task.update_attributes(post_params)
            render json: nil, status: :ok
          else
            render json: nil, status: :bad_request
          end
        end
      end

      def destroy
        if is_current_user_operator
          task = Task.find(params[:id])
          if task
            task.destroy
            render json: nil, status: :gone
          else
            render json: nil, status: :not_found
          end
          return
        end

        render json: nil, status: :not_found
      end

      private

      def post_params
        params.require(:task).permit(:title, :user_id, :patient, :diagnosis, :status)
      end

    end
  end
  end


