Rails.application.routes.draw do

  match '/signup',  to: 'api/v1/users#create',              via: 'post'
  match '/signin',  to: 'api/v1/user_sessions#create',      via: 'post'
  match '/signout', to: 'api/v1/user_sessions#destroy',     via: 'delete'

  namespace 'api' do
    namespace 'v1' do
      resources :tasks, defaults: {format: :json}
      resources :users, defaults: {format: :json}
      resources :user_sessions, only: [:new, :create, :destroy], defaults: {format: :json}

    end
  end
end
