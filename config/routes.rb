Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: :none do
    collection do
      post :signup
      post :login
    end
  end

  resources :loans, except: [:update, :delete] do
    member do
      put :approve
      get :repayments
    end
  end

  resources :repayments, only: :none do
    member do
      put :repay
    end
  end
end
