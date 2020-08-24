Rails.application.routes.draw do
  resources :flashcards, only: [:index, :create], defaults: { format: :json }
end
