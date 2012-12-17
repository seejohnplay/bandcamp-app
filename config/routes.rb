CourseProject::Application.routes.draw do
  root to: "main#index"

  resources :posts, :only => [:index, :new, :create, :show]
end
