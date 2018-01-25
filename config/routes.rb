Rails.application.routes.draw do
  get '/' => 'sessions#root'
  get '/run' => 'sessions#run'
  post '/import' => 'sessions#import'
  post '/login' => 'sessions#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
