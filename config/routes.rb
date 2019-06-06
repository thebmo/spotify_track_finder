Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/users/:id', to: 'test#show'
  get '/test', to: 'test#test', as: 'users_test'
  get '/spotify/sign_in', to: 'spotify#sign_in', as: 'spotify_sign_in'
  get '/auth/spotify/callback', to: 'spotify#callback', as: 'auth_spotify_callback'
  get '/band_tracks', to: 'spotify#band_tracks', as: 'band_tracks'

  #sessions controller
  get    '/login', to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
