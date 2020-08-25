module V1
  class FlashcardsController < ApplicationController
    skip_before_action :authorize_request

    # returns a list with all the filtered flashcards
    def index
      # this should be current user
      user = @current_user
      @flashcards = user.filtered_flashcards(params[:filter])
    end

    # creates a bunch of flashcards
    def create
      # this should be current user
      user = @current_user
      error_messages = []

      flashcards_bundle_params[:_json].each do |flashcard|
        f = user.flashcards.build(flashcard)

        unless f.save
          error_messages << f.errors.full_messages
        end
      end

      if error_messages.any?
        render json: { errors: error_messages.uniq }, status: :accepted
      else
        head :ok
      end
    end

    # edits a bunch of flashcards
    def update
      # this should be current user
      user = @current_user
      error_messages = []

      flashcards_bundle_update_params[:_json].each do |flashcard|
        f = Flashcard.find_by(id: flashcard[:id])

        unless f
          error_messages << 'Some flashcard ids can not be found'

          next
        end

        f_temp = user.flashcards.build(
          front: flashcard[:front],
          back: flashcard[:back]
        )

        if f_temp.valid?
          f.update(front: flashcard[:front], back: flashcard[:back])
        else
          error_messages << f_temp.errors.full_messages
        end
      end

      if error_messages.any?
        render json: { errors: error_messages.uniq }, status: :accepted
      else
        head :ok
      end
    end

    # destroys a bunch of flashcards
    def destroy
      @current_user.flashcards.where(id: flashcards_destroy_params[:ids]).delete_all

      head :ok
    end

    # answers a bunch of flashcards
    def answer
      user = @current_user # this should be current user
      error_messages = []
      email_sent = Array.new(3, false)

      flashcards_bundle_answer_params[:flashcards].each do |flashcard|
        f = Flashcard.find_by(id: flashcard[:id])

        unless f
          error_messages << 'Some flashcard ids can not be found'

          next
        end

        if flashcard[:correct] == "true" || flashcard[:correct] == true
          unless f.mastered?
            f.counter += 1
            f.waiting = true
            f.save

            case f.counter
            when 1 # first repetition
              SetWaitingStateJob.set(wait: 5.days).perform_later(f)

              unless email_sent[0]
                SendReminderEmailsJob.set(
                  wait: 5.days
                ).perform_later(user.email)

                email_sent[0] = true
              end
            when 2 # second repetition, 5 days later (relative to the last one)
              SetWaitingStateJob.set(wait: 10.days).perform_later(f)

              unless email_sent[1]
                SendRemainderEmailsJob.set(
                  wait: 10.days
                ).perform_later(user.email)

                email_sent[1] = true
              end
            when 3 # third repetition, 10 days later (relative to the last one)
              SetWaitingStateJob.set(wait: 14.days).perform_later(f)

              unless email_sent[2]
                SendRemainderEmailsJob.set(
                  wait: 14.days
                ).perform_later(user.email)

                email_sent[2] = true
              end
            when 4 # fourth repetition, 14 days later (relative to the last one)
              f.toggle!(:mastered)
              f.toggle!(:waiting)
            end
          end
        else # we rewind the progress to zero
          f.counter = 0
          f.mastered = false if f.mastered?
          f.waiting = false
          f.save
        end
      end

      if error_messages.any?
        render json: { errors: error_messages.uniq }, status: :accepted
      else
        head :ok
      end
    end

    private

    def flashcards_bundle_answer_params
      params.permit(flashcards: [:id, :correct])
    end

    def flashcards_bundle_params
      params.permit(_json: [:front, :back])
    end

    def flashcards_bundle_update_params
      params.permit(_json: [:id, :front, :back])
    end

    def flashcards_destroy_params
      params.permit(ids: [])
    end

  end
end

