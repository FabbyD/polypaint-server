Rails.application.routes.draw do
  post '/users', to: 'users#create'
  post   '/app-login',   to: 'logins#create'
  delete '/logout',  to: 'sessions#destroy' 

  get '/canvases', to: 'canvases#index'
  get '/canvases/:id', to: 'canvases#show'
  get '/users/:user_name/canvases', to: 'canvases#indexByUser'
  post '/canvases/login', to: 'canvases#authenticate'

  get '/pixel_canvases/:id', to: 'pixel_canvases#show'

  get '/chatrooms/:id', to: 'chatrooms#show'
end
