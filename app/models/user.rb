class User < ApplicationRecord
  # encrypt password
  has_secure_password
  
  # validations
  validates_presence_of :email, :password_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }
  has_many :flashcards
end
