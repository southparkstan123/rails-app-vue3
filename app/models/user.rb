class User < ApplicationRecord
  has_secure_password

  # relationships
  has_many :created_books, class_name: 'Book', foreign_key: 'creator_id', inverse_of: :creator
  has_many :updated_books, class_name: 'Book', foreign_key: 'updater_id', inverse_of: :updater

  has_many :created_publishers, class_name: 'Publisher', foreign_key: 'creator_id', inverse_of: :creator
  has_many :updated_publishers, class_name: 'Publisher', foreign_key: 'updater_id', inverse_of: :updater

  has_many :created_authors, class_name: 'Author', foreign_key: 'creator_id', inverse_of: :creator
  has_many :updated_authors, class_name: 'Author', foreign_key: 'updater_id', inverse_of: :updater

  # validation rules
  validates :username,
            length: { minimum: 5, too_short: 'at least %{count} characters' },
            presence: { message: 'is required' },
            uniqueness: { message: '%{value} is already taken' }
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'format is invalid' },
            uniqueness: { message: '%{value} is already taken' }
  validates :password,
            length: { minimum: 6, too_short: 'at least %{count} characters' },
            presence: { message: 'is required' },
            confirmation: true
end
