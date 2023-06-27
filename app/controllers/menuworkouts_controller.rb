class MenuworkoutsController < ApplicationController
  before_action :authenticate_user 
  before_action :ensure_correct_user

  def ensure_correct_user
    routine_id=Menu.find_by(id:params[:menu_id]).routine_id
    unless @current_user.id == Routine.find_by(id:routine_id).user_id
      flash[:notice]="権限がありません"
      redirect_to("/routines/index")
    end
  end
  
  def new
    @menu=Menu.find_by(id:params[:menu_id])
    @workout=Workout.find_by(id:params[:workout_id])
    @menuworkout=MenuWorkout.new
  end

  def choose_workout
    @workouts=Workout.where(user_id:@current_user.id)
    @menu=Menu.find_by(id:params[:menu_id])
  end

  def create
    @menu=Menu.find_by(id:params[:menu_id])
    @workout=Workout.find_by(name:params[:workout_name],user_id:@current_user.id)
    @menuworkout=MenuWorkout.new(workout_id:@workout.id,menu_id:@menu.id)
    if @menuworkout.save
      flash[:notice]="メニューに種目を登録しました"
      redirect_to("/menus/#{@menu.id}")
    else
      render("menuworkouts/new",status: :unprocessable_entity)
    end
  end

  def destroy
    @menuworkout=MenuWorkout.find_by(menu_id:params[:menu_id],workout_id:params[:workout_id])
    @menuworkout.destroy
    flash[:notice]="種目を削除しました"
    redirect_to("/menus/#{params[:menu_id]}")
  end
end
