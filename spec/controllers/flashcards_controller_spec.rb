require 'rails_helper'

RSpec.describe FlashcardsController, type: :controller do
  context 'Listing flashcards' do
    describe '#index' do
      before { get :index }

      it { should render_template('flashcards/index') }
    end
  end
end

