module Api
  module V1
    class ArticlesController < ApiController
      before_action :authenticate, except: [:index, :show]
      load_and_authorize_resource
      skip_load_resource only: [:create]

      # GET /api/articles
      def index
        render json: @articles
      end

      # GET /api/articles/1
      def show
        render json: @article
      end

      # POST /api/articles
      def create
        @article = current_user.articles.new(article_params)

        if @article.save
          render json: { success: true }, status: :created
        else
          render json: @article.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/articles/1
      def update
        if @article.update(article_params)
          render json: { success: true }
        else
          render json: @article.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/articles/1
      def destroy
        @article.destroy
        render json: { success: true }
      end

    private

      def article_params
        params.require(:article).permit(:title, :body)
      end
    end
  end
end
