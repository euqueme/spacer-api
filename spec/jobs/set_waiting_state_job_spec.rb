require 'rails_helper'

RSpec.describe SetWaitingStateJob, type: :job do
  before :all do
    create(:user)

    @flashcard = User.first.flashcards.create(
      front: 'a or b?',
      back: 'a'
    )

    ActiveJob::Base.queue_adapter = :test
  end

  it 'enqueues the job' do
    SetWaitingStateJob.perform_later(@flashcard)
    expect(SetWaitingStateJob).to have_been_enqueued
  end
end
