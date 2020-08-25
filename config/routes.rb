Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  concern :api_base do
    patch 'flashcards', to: 'flashcards#update', defaults: { format: :json }
    delete 'flashcards', to: 'flashcards#destroy', defaults: { format: :json }

    resources :flashcards, only: [:index, :create], defaults: { format: :json } do
      patch 'answer', on: :collection
    end

    post 'login', to: 'authentication#authenticate'
    post 'signup', to: 'users#create'
  end

  namespace :v1 do
    concerns :api_base
  end

  resources :account_activations, only: [:edit]
end

