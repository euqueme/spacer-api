class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email
  before_create :create_activation_digest
  
  # encrypt password
  has_secure_password

  # validations
  validates_presence_of :email, :password_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :email, :uniqueness => true, format: { with: VALID_EMAIL_REGEX }

  # associations
  has_many :flashcards

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")

    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end
  
  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end

    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

end

