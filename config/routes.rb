PushBack::Application.routes.draw do
  root to: "users#show"
  resource :user, except: [:new, :edit]
  resource :session, only: [:create, :destroy]

  resources :friendships, only: [:index, :destroy]
  resources :friend_requests, only: [:index, :create] do
    member do
      post 'accept'
      delete 'deny'
    end
  end

  resources :friend_invitations, only: [:create]

  resources :friends, only: [] do
    resources :messages, only: [:index, :create]
  end

  resources :workouts, except: [:new, :edit] do
    resources :workout_sets, only: [:create, :destroy]
  end

  match "*xxxx", to: "application#routing_error", via: [:get, :post, :put, :patch, :delete]
end
