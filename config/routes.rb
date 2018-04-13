Rails.application.routes.draw do
  post '/users', to: 'users#create'
  put '/users/:id', to: 'users#update'
  post '/app-login',   to: 'logins#create'
  post '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy' 

  get '/canvases', to: 'canvases#index'
  post '/canvases', to: 'canvases#create'
  get '/canvases/:id', to: 'canvases#show'
  put '/canvases/:id', to: 'canvases#update'
  get '/users/:user_name/canvases', to: 'canvases#indexByUser'
  post '/canvases/login', to: 'canvases#authenticate'

  get '/pixel_canvases/:id', to: 'pixel_canvases#show'
  post '/pixel_canvases', to: 'pixel_canvases#create'
  put '/pixel_canvases/:id', to: 'pixel_canvases#update'
  post '/pixel_canvases/login', to: 'pixel_canvases#authenticate'

  get '/chatrooms/:id', to: 'chatrooms#show'

  get '/users/:id/templates', to: 'templates#index'
  post '/users/:id/templates', to: 'templates#create'
end
