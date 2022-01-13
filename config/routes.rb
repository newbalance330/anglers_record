Rails.application.routes.draw do

  root to: 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  devise_for :users

  # ネストさせてる
  resources :users,only: [:show,:index,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :fish do
    resources :fish_comments, only: [:create, :destroy]
    resource :fish_favorites, only: [:create, :destroy]
  end

  resources :items

end
