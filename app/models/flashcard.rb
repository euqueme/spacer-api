class Flashcard < ApplicationRecord
  belongs_to :user
  validates :front, :back, :counter, presence: true
  validates :counter, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 4,
    only_integer: true
  }
end
