Rails.application.routes.draw do
  post '/users', to: 'users#create'
  post   '/app-login',   to: 'logins#create'
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
end
