Rails.application.routes.draw do
  devise_for :users
  root to: "posts#index"

  get 'tags/:tag', to: 'posts#index', as: :tag

  resources :posts, :only => [:index, :new, :create, :show, :destroy] do
    resources :votes, only: [:create]
    resources :comments, only: [:index, :new, :create]
  end

end
