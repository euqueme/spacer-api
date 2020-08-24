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
      render json: { errors: error_messages.unique }, status: :accepted
    else
      head :ok
    end
  end

  # edits a bunch of flashcards
  def update
    # this should be current user
    user = User.first
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
      render json: { errors: error_messages.unique }, status: :accepted
    else
      head :ok
    end
  end

  # destroys a bunch of flashcards
  def destroy
    User.first.flashcards.where(id: flashcards_destroy_params[:ids]).delete_all

    head :ok
  end

  private

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

