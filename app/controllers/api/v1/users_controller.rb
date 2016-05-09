module Api
  module V1
    class UsersController < ApiController
      before_action :authenticate
      load_and_authorize_resource
      skip_load_resource only: [:create]

      # GET /api/users
      def index
        render json: @users
      end

      # GET /api/users/1
      def show
        render json: @user
      end

      # POST /api/users
      def create
        @user = User.new(user_params)

        if @user.save
          render json: { success: true }, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/users/1
      def update
        if @user.update(user_params)
          render json: { success: true }
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/users/1
      def destroy
        @user.destroy
        render json: { success: true }
      end

    private

      def user_params
        if current_user.admin?
          params.require(:user).permit(:name, :email, :password, :role)
        else
          params.require(:user).permit(:name, :email, :password)
        end
      end
    end
  end
end
