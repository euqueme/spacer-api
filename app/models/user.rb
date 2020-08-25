class User < ApplicationRecord

  # encrypt password
  has_secure_password

  # validations
  validates_presence_of :email, :password_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }

  # associations
  has_many :flashcards

  # filters the user flashcards
  def filtered_flashcards(filter)
    case filter
    when 'active'
      flashcards.where(waiting: false)
    when 'waiting'
      flashcards.where(waiting: true)
    when 'mastered'
      flashcards.where(mastered: true)
    end
  end

end

