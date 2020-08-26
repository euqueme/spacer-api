require 'rails_helper'

RSpec.describe V1::FlashcardsController, type: :controller do
  before :all do
    user = create(:user)
    @token = AuthenticateUser.new(user.email, 'foobar').call
  end

  before :each do
    request.headers['Authorization'] = @token
  end

  context 'listing flashcards' do
    describe '#index' do
      before do
        get :index, params: { filter: 'active' }
      end

      it { should render_template }
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

  context 'answering flashcards' do
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
          },
          {
            front: 'e or f?',
            back: 'e'
          }
        ]
      )
    end

    let(:flashcards) { Flashcard.first(3) }
    let(:ids) { Flashcard.select(:id).first(3).map(&:id) }

    context 'all flashcards are correct' do
      it 'increases the counter for all the flashcards' do
        patch :answer, params: {
          flashcards: [
            {
              id: ids[0],
              correct: true
            },
            {
              id: ids[1],
              correct: true
            },
            {
              id: ids[2],
              correct: true
            }
          ]
        }

        expect(flashcards.all? do |flashcard|
          flashcard.reload.counter == 1
        end).to be_truthy
      end
    end

    context 'none of the flashcards is correct' do
      it 'does not increase the counter for any of the flashcards' do
        patch :answer, params: {
          flashcards: [
            {
              id: ids[0],
              correct: false
            },
            {
              id: ids[1],
              correct: false
            },
            {
              id: ids[2],
              correct: false
            }
          ]
        }

        expect(flashcards.all? do |flashcard|
          flashcard.reload.counter.zero?
        end).to be_truthy
      end
    end

    context 'some flashcards are correct' do
      it 'increases the counter for at least one of the flashcards' do
        patch :answer, params: {
          flashcards: [
            {
              id: ids[0],
              correct: true
            },
            {
              id: ids[1],
              correct: false
            },
            {
              id: ids[2],
              correct: false
            }
          ]
        }

        expect(flashcards.any? do |flashcard|
          flashcard.reload.counter == 1
        end).to be_truthy
      end
    end
  end
end

