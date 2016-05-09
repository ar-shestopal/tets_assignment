module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :name, :email

      has_many :articles, embed: :id
      has_many :comments, embed: :id
    end
  end
end
