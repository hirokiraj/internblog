Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  root 'home#index'

  resources :authors

  namespace :api do
    namespace :v1 do
      defaults format: :json do
        resources :posts, except: [:new, :edit]
      end
    end
  end
end
