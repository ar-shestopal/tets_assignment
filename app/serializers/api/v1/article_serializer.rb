module Api
  module V1
    class ArticleSerializer < ActiveModel::Serializer
      attributes :title, :body, :created_at, :user_id

      has_many :comments, embed: :id
    end
  end
end
