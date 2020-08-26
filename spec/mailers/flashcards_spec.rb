require "rails_helper"

RSpec.describe FlashcardsMailer, type: :mailer do
  before :all do
    @user = create(:user)
    # @token = AuthenticateUser.new(@user.email, 'foobar').call

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

  # before :each do
  #   request.headers['Authorization'] = @token
  # end

  context 'answering flashcards' do
    describe '#notify_repetition_success' do
      let(:mail) do
        FlashcardsMailer.with(
          user_email: @user.email
        ).notify_repetition_success
      end

      it 'notifies next repetition time' do
        expect(mail.subject).to eq('It is terminology practice time!')
        expect(mail.to).to eq([@user.email])
        expect(mail.from).to eq(['spaced-repetition.no-reply@sandbox84d371bcf5924ad1bc3f53bd72fee228.com'])
      end

      it 'contains a link to the home page' do
        expect(mail.body.encoded).to match(
          url_for(
            protocol: 'https',
            host: 'spaced-repetition-api.herokuapp.com',
            controller: 'v1/flashcards',
            action: 'index'
          )
        )
      end
    end
  end
end

