module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :authorize, except: [:create]
      def index
      @users = User.order('created_at DESC')
      end

      def create
        @user = User.new(user_params)
        if @user
          if params[:dispather_code] == 'root'
            @user.role = 1
          end
        end
        if @user.save
          render status: :created
        else
          render @user.errors, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :password, :password_confirmation)
      end

    end
  end
end