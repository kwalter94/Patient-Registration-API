Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'api#index'

  resources :users do
   member do
     get :delete
   end
 end

 resources :patients do
  member do
    get :delete
  end
end
end
