Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
	get 'slack_oauth', to: 'sessions#slack_oauth'
  get 'slack/oauth/callback', to: 'sessions#slack_oauth_callback'
	post '/slack/upload', to: 'uploads#create'

  get 'welcome/home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  root 'welcome#home'

end
