Rails.application.routes.draw do
  root to: "posts#index"

  get 'tags/:tag', to: 'posts#index', as: :tag

  resources :posts, :only => [:index, :new, :create, :show, :destroy] do
    resources :votes, only: [:create]
  end
end
