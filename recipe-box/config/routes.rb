Rails.application.routes.draw do

  resources :recipes
  resources :ingredients
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get '/profile' => 'users#profile'
  post '/recipes' => 'recipes#create'
  patch '/edit-recipe' => 'recipes#update'
  patch '/edit-ingredient' => 'ingredients#update'
  delete '/delete' => 'ingredients#destroy'
  resources :users

end
