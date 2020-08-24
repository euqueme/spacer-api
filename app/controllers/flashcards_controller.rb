class FlashcardsController < ApplicationController

  # returns a list with all the filtered flashcards
  def index
    user = User.first
    @flashcards = user.filtered_flashcards(params[:filter])
  end

end

