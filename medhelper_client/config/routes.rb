Rails.application.routes.draw do
  resources :user_auth
  resources :registration_user
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to => 'welcome#index'
  resources :tasks
  get 'sign_out', to: 'user_auth#sign_out', as: :sign_out
  get 'tasks/complete/:id', to: 'tasks#complete'
  put 'tasks/complete/:id', to: 'tasks#complete'
  put 'tasks/delete_task/:id', to: 'tasks#delete_task'
end
