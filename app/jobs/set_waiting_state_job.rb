class SetWaitingStateJob < ApplicationJob
  queue_as :default

  def perform(flashcard)
    flashcard.toggle!(:waiting)
  end
end
