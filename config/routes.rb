Rails.application.routes.draw do
  patch 'flashcards', to: 'flashcards#update', defaults: { format: :json }
  delete 'flashcards', to: 'flashcards#destroy', defaults: { format: :json }
  resources :flashcards, only: [:index, :create], defaults: { format: :json }
end

