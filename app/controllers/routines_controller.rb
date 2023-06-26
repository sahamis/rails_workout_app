class RoutinesController < ApplicationController
  before_action :authenticate_user 
  
  def index
    @routines=Routine.where(user_id:@current_user.id)
  end

  def new
    @routine=Routine.new
  end

  def create
    @routine=Routine.new(name:params[:name],user_id:@current_user.id)
    if @routine.save
      flash[:notice]="新規計画を登録しました"
      redirect_to("/routines/index")
    else 
      render("routines/new",status: :unprocessable_entity)
    end
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
    if @routine.save
      flash[:notice]="編集内容を登録しました"
      redirect_to("/routines/#{@routine.id}")
    else
      render("routines/edit",status: :unprocessable_entity)
    end
  end 

  def destroy
    @routine=Routine.find_by(id:params[:routine_id])
    @routine.destroy
    flash[:notice]="計画を削除しました"
    redirect_to("/routines/index")
  end
end
