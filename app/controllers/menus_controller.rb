class MenusController < ApplicationController
  def new
    @routine=Routine.find_by(id:params[:routine_id])
  end

  def create
    @menu=Menu.new(name:params[:name],routine_id:params[:routine_id])
    @menu.save
    redirect_to("/routines/#{params[:routine_id]}")
  end
  
  def show
    @menu=Menu.find_by(id:params[:menu_id])
    @menuworkouts=MenuWorkout.where(menu_id:@menu.id)
    @menuworkouts_id=(@menuworkouts).map{|menuworkout|menuworkout.workout_id}
    @workouts=Workout.where(id:@menuworkouts_id)
  end

  def edit
    @menu=Menu.find_by(id:params[:menu_id])
  end

  def update
    @menu=Menu.find_by(id:params[:menu_id])
    @menu.name=params[:menu_name]
    @menu.save
    redirect_to("/menus/#{@menu.id}")
  end

  def destroy
    @menu=Menu.find_by(id:params[:menu_id])
    @routine_id=@menu.routine_id
    @menu.destroy
    redirect_to("/routines/#{@routine_id}")
  end
end
