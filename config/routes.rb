Rails.application.routes.draw do
  get '/' => "home#top"
  
  get "signup" => "users#new"

  get "record/index" => "record#index"
  get "record/:date/new" => "record#new"
  post "record/:date/create" => "record#create"
  get "record/workout" => "record#workout"
  post "record/workout_create" => "record#workout_create"
  get "record/:date" => "record#show"
end
