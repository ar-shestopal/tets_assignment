module Api
  module V1
    class CommentSerializer < ActiveModel::Serializer
      attributes :body, :created_at, :user_id, :article_id
    end
  end
end
