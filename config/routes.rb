TheCatch::Application.routes.draw do
  resources :documents, only: [:index]

  get '/login'      => 'home#login'
  get '/register'   => 'home#register'

  root to: 'home#landing'
end
