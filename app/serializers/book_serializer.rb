class BookSerializer < ApplicationSerializer
  attributes :id, :name, :price, :abstract, :created_at, :updated_at

  has_many :authors, serializer: AuthorSerializer
  belongs_to :creator, serializer: UserSerializer
  belongs_to :updater, serializer: UserSerializer
  belongs_to :publisher, serializer: PublisherSerializer

  def price
    object.price.to_f
  end
  
end

