require 'date'

class RecordController < ApplicationController
  def index
    @sets=WorkoutSet.all
  end

  def new
    @date=params[:date]
  end

  def create
    @date=Date.parse(params[:date])
    if WorkoutDate.find_by(date:@date)
      @workoutdate=WorkoutDate.find_by(date:@date)
    else
      @workoutdate=WorkoutDate.new(date:@date)
      @workoutdate.save
    end
    @set=WorkoutSet.new(
      user_id:@current_user.id,
      workout_id:Workout.find_by(name:params[:name]).id,
      date_id:@workoutdate.id,
      weight:params[:weight],
      repetitions:params[:repetitions]
    )
    @set.save
    redirect_to("/record/index")
  end

  def workout
  end

  def workout_create
    @workout=Workout.new(name:params[:name])
    @workout.save
    redirect_to("/record/index")
  end

  def show
    @string_date=params[:date]
    @date=Date.parse(params[:date])
    @workoutdate=WorkoutDate.find_by(date:@date)
    if @workoutdate
       @workoutsets=WorkoutSet.where(date_id:@workoutdate.id)
    else
      @message="種目が登録されていません"
    end
  end
end
