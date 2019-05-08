Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/users/:id', to: 'test#show'
  get '/test', to: 'test#test', as: 'users_test'

  get '/tracks', to: 'spotify#list_tracks', as: 'spotify_tracks'
end
