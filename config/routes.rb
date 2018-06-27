Rails.application.routes.draw do
  resources :people
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'api#index'
  post '/login', to: 'users#login'
  get '/login', to: 'users#check_login' # Returns logged in user if any
  get '/logout', to: 'users#logout'

  resources :users
  resources :patients
  resources :roles
  resources :privileges
end
