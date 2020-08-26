class FlashcardsMailer < ApplicationMailer
  def notify_repetition_success
    @url = url_for(
      protocol: 'https',
      host: 'spaced-repetition-api.herokuapp.com',
      controller: 'v1/flashcards',
      action: 'index'
    )

    mail(to: params[:user_email], subject: 'It is terminology practice time!')
  end
end
