class MenuworkoutsController < ApplicationController
  
  def new
    @menu=Menu.find_by(id:params[:menu_id])
    @workout=Workout.find_by(id:params[:workout_id])
  end

  def choose_workout
    @workouts=Workout.all
    @menu=Menu.find_by(id:params[:menu_id])
  end

  def create
    @menu=Menu.find_by(id:params[:menu_id])
    @workout=Workout.find_by(name:params[:workout_name])
    @menuworkout=MenuWorkout.new(workout_id:@workout.id,menu_id:@menu.id)
    @menuworkout.save
    flash[:notice]="メニューに種目を登録しました"
    redirect_to("/menus/#{@menu.id}")
  end

  def destroy
    @menuworkout=MenuWorkout.find_by(menu_id:params[:menu_id],workout_id:params[:workout_id])
    @menuworkout.destroy
    flash[:notice]="種目を削除しました"
    redirect_to("/menus/#{params[:menu_id]}")
  end
end
