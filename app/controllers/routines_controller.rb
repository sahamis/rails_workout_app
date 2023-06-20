class RoutinesController < ApplicationController
  def index
    @routines=Routine.all
  end

  def new
  end

  def create
    @routine=Routine.new(name:params[:name])
    @routine.save
    redirect_to("/routines/index")
  end

  def show
    @routine=Routine.find_by(id:params[:routine_id])
    @menus=Menu.where(routine_id:@routine.id)
  end

  def edit
    @routine=Routine.find_by(id:params[:routine_id])
  end

  def update
    @routine=Routine.find_by(id:params[:routine_id])
    @routine.name=params[:routine_name]
    @routine.save
    redirect_to("/routines/#{@routine.id}")
  end 

  def destroy
    @routine=Routine.find_by(id:params[:routine_id])
    @routine.destroy
    redirect_to("/routines/index")
  end
end
