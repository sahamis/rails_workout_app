Rails.application.routes.draw do
 
  get '/' => "home#top"
  
  get "signup" => "users#new"
  post "users/create" => "users#create"
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"

  get "users/index" => "users#index"
  get "users/:user_id" => "users#show"
  get "users/:user_id/edit" => "users#edit"
  post "users/:user_id/update" => "users#update"
  post "users/:user_id/destroy" => "users#destroy"

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

  get 'routines/index' => "routines#index"
  get "routines/new" => "routines#new"
  post "routines/create" => "routines#create"
  get "routines/:routine_id" => "routines#show"
  get "routines/:routine_id/edit" => "routines#edit"
  post "routines/:routine_id/update" => "routines#update"
  post "routines/:routine_id/destroy" => "routines#destroy"

  get 'menus/:routine_id/new' => "menus#new"
  post "menus/:routine_id/create" => "menus#create"
  get "menus/:menu_id" => "menus#show"
  get "menus/:menu_id/edit" => "menus#edit"
  post "menus/:menu_id/update" => "menus#update"
  post "menus/:menu_id/destroy" => "menus#destroy"

  get "menuworkouts/:menu_id/new/:workout_id" => "menuworkouts#new"
  get "menuworkouts/:menu_id/choose_workout" => "menuworkouts#choose_workout"
  post "menuworkouts/:menu_id/create" => "menuworkouts#create"
  post "menuworkouts/:menu_id/destroy/:workout_id" => "menuworkouts#destroy"
  
end
