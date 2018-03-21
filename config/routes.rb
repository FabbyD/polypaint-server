Rails.application.routes.draw do
  post '/users', to: 'users#create'
  post   '/app-login',   to: 'logins#create'
  delete '/logout',  to: 'sessions#destroy' 
  get '/canvas/:id', to: 'canvases#get'
end
