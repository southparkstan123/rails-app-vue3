class AuthorSerializer < ApplicationSerializer
  attributes :id, :name, :description, :created_at, :updated_at

  belongs_to :creator, serializer: UserSerializer
  belongs_to :updater, serializer: UserSerializer
  belongs_to :books, serializer: BookSerializer
end
