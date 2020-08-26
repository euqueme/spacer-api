require 'rails_helper'

RSpec.describe SendReminderEmailsJob, type: :job do
  before :all do
    ActiveJob::Base.queue_adapter = :test
  end

  it 'enqueues the job' do
    expect do
      SendReminderEmailsJob.perform_later('bob@example.com')
    end.to have_enqueued_job
  end
end
