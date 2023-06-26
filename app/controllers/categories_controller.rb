class CategoriesController < ApplicationController
  before_action :authenticate_user 

  def new
    @category=Category.new
  end

  def create
    @category=Category.new(name:params[:name],user_id:@current_user.id)
    if @category.save
      flash[:notice]="新規カテゴリーを登録しました"
      if params[:workout_id].present?
        @workout_id=params[:workout_id]
        if @workout_id==0
          redirect_to("/workouts/new/#{@category.id}")   
        else
          redirect_to("/workouts/#{@workout_id}/edit/#{@category.id}") 
        end
      else
        redirect_to("/categories/index")
      end
    else
      render("categories/new",status: :unprocessable_entity)
    end
  end

  def index
    @categories=Category.where(user_id:@current_user.id)
    unless @categories.present?
      @error_message="種目が登録されていません"
    end
  end

  def show
    @category=Category.find_by(id:params[:category_id])
    @category_workouts=Workout.where(category_id:@category.id,user_id:@current_user.id)
    unless @category_workouts.present?
      @error_message="種目が登録されていません"
    end
  end

  def edit
    @category=Category.find_by(id:params[:category_id])
  end

  def update
    @category=Category.find_by(id:params[:category_id])
    @category.name=params[:category_name]
    if @category.save
      flash[:notice]="編集内容を登録しました"
      redirect_to("/categories/#{@category.id}")
    else
      render("categories/edit",status: :unprocessable_entity)
    end
  end

  def new_workout
    @category=Category.find_by(id:params[:category_id])
    @workouts=Workout.where(user_id:@current_user.id)
    @workout=Workout.find_by(id:params[:workout_id])
  end

  def update_workout
    @category=Category.find_by(id:params[:category_id])
    @workout=Workout.find_by(name:params[:workout_name],user_id:@current_user.id)
    @workout.category_id=@category.id
    @workout.save
    flash[:notice]="編集内容を登録しました"
    redirect_to("/categories/#{@category.id}")
  end
end
