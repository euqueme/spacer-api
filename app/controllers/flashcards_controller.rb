class FlashcardsController < ApplicationController

  # returns a list with all the filtered flashcards
  def index
    # this should be current user
    user = User.first
    @flashcards = user.filtered_flashcards(params[:filter])
  end

  # creates a bunch of flashcards
  def create
    # this should be current user
    user = User.first
    error_messages = []

    flashcards_bundle_params[:_json].each do |flashcard|
      f = user.flashcards.build(flashcard)

      unless f.save
        error_messages << f.errors.full_messages
      end
    end

    if error_messages.any?
      render json: { errors: error_messages }, status: :ok
    else
      head :ok
    end
  end

  private

  def flashcards_bundle_params
    params.permit(_json: [:front, :back])
  end

end

