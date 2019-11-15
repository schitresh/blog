Rails.application.routes.draw do
  get 'welcome/home', to: "welcome#home"
  get 'welcome/about', to: "welcome#about"
  root to: "welcome#home"
  resources :articles

  get 'signup', to: "users#new"
  post 'users', to: "users#create"
  resources :users, except: [:new]

  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'login', to: "sessions#destroy"
end
