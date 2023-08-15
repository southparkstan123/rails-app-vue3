class Publisher < ApplicationRecord
  # validation rules
  validates :name,
            presence: { message: 'is required' },
            uniqueness: { message: '%{value} is already taken' }
  validates :description,
            presence: { message: 'is required' }
  
  # A Publisher record can be created and updated by user
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id, inverse_of: :created_books
  belongs_to :updater, class_name: 'User', foreign_key: :updater_id, inverse_of: :updated_books

  # A Publisher has published many books
  has_many :books, dependent: :destroy
end
