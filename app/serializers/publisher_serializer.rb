class PublisherSerializer < ApplicationSerializer
  attributes :id, :name, :description, :created_at, :updated_at

  belongs_to :creator, serializer: UserSerializer
  belongs_to :updater, serializer: UserSerializer
  has_many :books, serializer: BookSerializer
end

