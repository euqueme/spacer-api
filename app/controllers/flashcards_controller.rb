class FlashcardsController < ApplicationController

  # returns a list with all the filtered flashcards
  def index
    @flashcards = Flashcard.all
  end

end

