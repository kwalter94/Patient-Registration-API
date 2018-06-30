Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'api#index'

  get 'login', to: 'users#check_login' # Returns logged in user if any
  post 'login', to: 'users#login'
  post 'logout', to: 'users#logout'

  resources :people
  post 'people/search', to: 'people#search'

  resources :patients
  post 'patients/search', to: 'patients#search'

  resources :users
  resources :roles
  resources :privileges
end
