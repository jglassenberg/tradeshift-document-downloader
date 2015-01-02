TheCatch::Application.routes.draw do
  resources :documents, only: [:index]

  root to: 'home#landing'
end
