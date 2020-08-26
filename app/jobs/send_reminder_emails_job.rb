class SendReminderEmailsJob < ApplicationJob
  queue_as :default

  def perform(user_email)
    FlashcardsMailer.with(
      user_email: user_email
    ).notify_repetition_success.deliver_later
  end
end

