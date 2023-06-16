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

  get "workouts/new/:category_id" => "workouts#new"
  post "workouts/create" => "workouts#create"
  get "workouts/choose_category" => "workouts#choose_category"
  get "workouts/:workout_id" => "workouts#show"
  get "workouts/:workout_id/edit" => "workouts#edit"
  post "workouts/:workout_id/update" => "workouts#update"
  get "workouts/:workout_id/sets_edit/:date_id" => "workouts#sets_edit"
  post "workouts/:workout_id/sets_update/:date_id" => "workouts#sets_update"

  get 'categories/new' => "categories#new"
  post "categories/create" => "categories#create"
  get "categories/index" => "categories#index"
  get "categories/:category_id" => "categories#show"
end
