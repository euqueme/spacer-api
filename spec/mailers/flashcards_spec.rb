require "rails_helper"

RSpec.describe FlashcardsMailer, type: :mailer do
  before :all do
    create(:user)

    User.first.flashcards.create([
      {
        front: 'a or b?',
        back: 'b'
      },
      {
        front: 'c or d?',
        back: 'c'
      }
    ])
  end

  context 'answering flashcards' do
    describe '#notify_repetition_success' do
      let(:mail) do
        FlashcardsMailer.with(
          user_email: User.first.email
        ).notify_repetition_success
      end

      it 'notifies next repetition time' do
        expect(mail.subject).to eq('It is terminology practice time!')
        expect(mail.to).to eq([User.first.email])
        expect(mail.from).to eq(['spaced-repetition.no-reply@mailgun.net'])
      end

      it 'contains a link to the home page' do
        expect(mail.body.encoded).to match(
          url_for(
            protocol: 'https',
            host: 'spaced-repetition-api',
            controller: 'flashcards',
            action: 'index'
          )
        )
      end
    end
  end
end

