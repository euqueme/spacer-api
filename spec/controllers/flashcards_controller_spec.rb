require 'rails_helper'

RSpec.describe FlashcardsController, type: :controller do
  before :all do
    create(:user)
  end

  context 'Listing flashcards' do
    describe '#index' do
      before do
        get :index
      end

      it { should render_template('flashcards/index') }
    end
  end

  context 'creating flashcards' do
    describe '#create' do
      it 'creates several flash cards at once' do
        previous_count = Flashcard.count

        post :create, params: {
          _json: [
            {
              front: 'a or b?',
              back: 'b'
            },
            {
              front: 'c or d?',
              back: 'c'
            }
          ]
        }

        expect(previous_count + 2).to eq(Flashcard.count)
      end
    end
  end
end

