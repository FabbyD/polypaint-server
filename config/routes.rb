Rails.application.routes.draw do
  post '/users', to: 'users#create'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy' 
end
