Rails.application.routes.draw do
  get '/' => "home#top"
  
  get "signup" => "users#new"
  post "users/create" => "users#create"
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"

  get "record/index" => "record#index"
  get "record/:date/new/:id" => "record#new"
  post "record/:date/create" => "record#create"
  get "record/:date/choose_workout" => "record#choose_workout"
  get "record/workout" => "record#workout"
  post "record/workout_create" => "record#workout_create"
  get "record/:date" => "record#show"
end
