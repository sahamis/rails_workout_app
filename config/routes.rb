Rails.application.routes.draw do
  get '/' => "home#top"
  
  get "signup" => "users#new"
  post "users/create" => "users#create"
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"

  get "record/index/:month" => "record#index"
  get "record/:date/new/:workout_id" => "record#new"
  post "record/:date/create" => "record#create"
  get "record/:date/choose_workout" => "record#choose_workout"
  get "record/:date" => "record#show"
  get "record/:date_id/edit/:workout_id" => "record#edit"
  post "record/:date_id/update/:workout_id" => "record#update"
  post "record/:date_id/destroy/:workout_id" => "record#destroy"

  get "workouts/new" => "workouts#new"
  post "workouts/create" => "workouts#create"
end
