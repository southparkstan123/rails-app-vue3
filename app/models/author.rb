class Author < ApplicationRecord
  validates :name,
            presence: { message: 'is required' },
            uniqueness: { message: '%{value} is already taken' }
  validates :description,
            presence: { message: 'is required' }

  # An Author record can be created and updated by a user
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id, inverse_of: :created_books
  belongs_to :updater, class_name: 'User', foreign_key: :updater_id, inverse_of: :updated_books

  # An anthor writes many books
  has_and_belongs_to_many :books
end
