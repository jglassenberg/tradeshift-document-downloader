TheCatch::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  ActiveAdmin.routes(self)

  # user_root overrides device's after-login route
  match 'dashboard' => 'user#dashboard', :as => 'user_root', via: [:get, :post]

  root to: 'home#landing'
end
