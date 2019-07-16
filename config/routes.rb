Rails.application.routes.draw do
  devise_for :users
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
