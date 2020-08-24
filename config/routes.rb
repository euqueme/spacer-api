Rails.application.routes.draw do
  resources :flashcards, only: :index, defaults: { format: :json }
end
