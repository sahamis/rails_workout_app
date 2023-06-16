class CategoriesController < ApplicationController

  def new
  end

  def create
    @category=Category.new(name:params[:name])
    if @category.save
      redirect_to("/record/index/#{@this_month}")
    else
      render("categories/new",status: :unprocessable_entity)
    end
  end

  def index
    @categories=Category.all
  end

  def show
    @category_workouts=Workout.where(category_id:params[:category_id])
  end
end
