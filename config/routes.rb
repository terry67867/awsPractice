Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  resources :blogs
  #index
  root 'posts#index'
  #rake routes -> 내가 가진 경로들을 다 볼 수 있다.
  resources :posts
  # get '/posts' => 'posts#index'
  # #Create
  # get '/posts/new' => 'posts#new'
  # post '/posts' => 'posts#create'
  # #Read
  # get '/posts/:id' => 'posts#show'
  # #Update
  # get '/posts/:id/edit' => 'posts#edit'
  # put '/posts/:id' => 'posts#update'
  # #Delete
  # delete '/posts/:id' => 'posts#destroy'

  get '/users/index' => 'users#index'
end
