require 'rails_helper'

RSpec.describe Flashcard, type: :model do
  it { should validate_presence_of(:front) }
  it { should validate_presence_of(:back) }
  it { should validate_presence_of(:counter) }
  it { should belong_to(:user) }
  it { should validate_numericality_of(:counter) }
end

