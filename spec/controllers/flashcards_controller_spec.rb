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

  context 'editing flashcards' do
    describe '#update' do
      before :all do
        User.first.flashcards.create(
          [
            {
              front: 'a or b?',
              back: 'b'
            },
            {
              front: 'c or d?',
              back: 'd'
            }
          ]
        )
      end

      it 'edits several flashcards at once' do
        flashcard1 = Flashcard.first
        flashcard2 = Flashcard.last

        patch :update, params: {
          _json: [
            {
              id: flashcard1.id,
              front: 'hakuna matata',
              back: 'yes'
            },
            {
              id: flashcard2.id,
              front: 'mike wasawski',
              back: 'green'
            }
          ]
        }

        expect(flashcard1.reload.front).to eq('hakuna matata')
        expect(flashcard1.reload.back).to eq('yes')
        expect(flashcard2.reload.front).to eq('mike wasawski')
        expect(flashcard2.reload.back).to eq('green')
      end
    end
  end

  context 'deleting flashcards' do
    before :all do
      User.first.flashcards.create(
        [
          {
            front: 'a or b?',
            back: 'b'
          },
          {
            front: 'c or d?',
            back: 'd'
          }
        ]
      )
    end

    let(:flashcard1) { Flashcard.first }
    let(:flashcard2) { Flashcard.last }

    describe '#destroy' do
      it 'deletes several flashcards at once' do
        previous_count = Flashcard.count

        delete :destroy, params: {
          ids: [
            flashcard1.id,
            flashcard2.id
          ]
        }

        expect(previous_count - 2).to eq(Flashcard.count)
      end
    end
  end
end

