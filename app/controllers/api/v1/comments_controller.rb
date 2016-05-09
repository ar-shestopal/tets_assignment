module Api
  module V1
    class CommentsController < ApiController
      before_action :authenticate, except: [:index, :show]
      load_and_authorize_resource
      skip_load_resource only: [:create]

      # GET /api/comments
      def index
        render json: @comments
      end

      # GET /api/comments/1
      def show
        render json: @comment
      end

      # POST /api/comments
      def create
        @comment = current_user.comments.new(comment_params)

        if @comment.save
          render json: { success: true }, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/comments/1
      def update
        if @comment.update(comment_params)
          render json: { success: true }
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/comments/1
      def destroy
        @comment.destroy
        render json: { success: true }
      end

    private

      def comment_params
        params.require(:comment).permit(:body, :article_id)
      end
    end
  end
end