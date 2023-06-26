class MenusController < ApplicationController
  before_action :authenticate_user 

  def new
    @menu=Menu.new
    @routine=Routine.find_by(id:params[:routine_id])
  end

  def create
    @routine=Routine.find_by(id:params[:routine_id])
    @menu=Menu.new(name:params[:name],
      routine_id:@routine.id)
    if @menu.save
      flash[:notice]="新規メニューを登録しました"
      redirect_to("/routines/#{params[:routine_id]}")
    else
      render("menus/new",status: :unprocessable_entity)
    end
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
    if @menu.save
      flash[:notice]="編集内容を登録しました"
      redirect_to("/menus/#{@menu.id}")
    else
      render("menus/edit",status: :unprocessable_entity)
    end
  end

  def destroy
    @menu=Menu.find_by(id:params[:menu_id])
    @routine_id=@menu.routine_id
    @menu.destroy
    flash[:notice]="メニューを削除しました"
    redirect_to("/routines/#{@routine_id}")
  end
end
