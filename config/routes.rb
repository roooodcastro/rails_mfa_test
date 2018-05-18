Rails.application.routes.draw do
  root to: 'users#index'

  resources :users do
    resource :mfa, only: [:create], controller: 'users/mfa' do
      collection { delete :destroy }
    end
  end

  resources :sessions, only: [:new, :create] do
    collection do
      post :new_mfa
      delete :destroy
    end
  end
end
