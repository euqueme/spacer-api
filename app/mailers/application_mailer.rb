class ApplicationMailer < ActionMailer::Base
  default from: 'spaced-repetition.no-reply@mailgun.net'
  layout 'mailer'
end
