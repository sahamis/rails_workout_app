class WorkoutsController < ApplicationController
  before_action :get_today ,{only:[:create]}
  def new
  end

  def create
    @workout=Workout.new(name:params[:name])
    @workout.save
    redirect_to("/record/index/#{@this_month}")
  end
end
