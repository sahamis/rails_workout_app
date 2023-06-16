class WorkoutsController < ApplicationController
  def new
    @category=Category.find_by(id:params[:category_id])
  end

  def create
    @workout=Workout.new(
      name:params[:name],
      category_id:Category.find_by(name:params[:category_name]).id)
    @workout.save
    redirect_to("/record/index/#{@this_month}")
  end

  def choose_category
    @categories=Category.all
  end

  def show
    @workout=Workout.find_by(id:params[:workout_id])
    @workout_sets=WorkoutSet.where(workout_id:params[:workout_id])
    @date_id=@workout_sets.distinct.pluck(:date_id)
    @dates=WorkoutDate.where(id:@date_id).sort_by{|date|date.date}.reverse
    @date_sets={}
    @dates.each do |date|
      @date_sets["date_#{date.id}"]=@workout_sets.where(date_id:date.id)
    end
  end

  def edit
    @workout=Workout.find_by(id:params[:workout_id])
    @workout_category=Category.find_by(id:@workout.category_id)
  end

  def update
    @workout=Workout.find_by(id:params[:workout_id])
    @workout.name=params[:workout_name]
    @workout.category_id=Category.find_by(name:params[:workout_category]).id
    @workout.save
    redirect_to("/workouts/#{@workout.id}")
  end

  def sets_edit
    @date=WorkoutDate.find_by(id:params[:date_id])
    @workout=Workout.find_by(id:params[:workout_id])
    @workout_sets=WorkoutSet.where(date_id:params[:date_id],workout_id:params[:workout_id])
  end

  def sets_update
    @workout_sets=WorkoutSet.where(workout_id:params[:workout_id],date_id:params[:date_id])
    for count in 0..4 do
      weight_param=params[:"weight_#{count}"]
      repetitions_param=params[:"repetitions_#{count}"]
      workout_set=@workout_sets[count]
      #WorkoutSetが存在する場合の処理
      if workout_set
        if weight_param.present? && repetitions_param.present? 
          workout_set.weight=weight_param
          workout_set.repetitions=repetitions_param
          workout_set.save
        elsif weight_param.present? || repetitions_param.present? 
          @error="エラー1です"
          render("workouts/sets_edit",status: :unprocessable_entity) and return
        else 
          workout_set.destroy
        end
      #WorkoutSetが存在しない場合の処理
      else
        if weight_param.present? && repetitions_param.present? 
          new_workout_set=WorkoutSet.new(
            user_id:@current_user.id,
            workout_id:params[:workout_id],
            date_id:params[:date_id],
            weight:weight_param,
            repetitions:repetitions_param,
            set_count:count+1
            )
          new_workout_set.save
        elsif weight_param.present? || repetitions_param.present? 
          @error="エラー2です"
          render("workouts/sets_edit",status: :unprocessable_entity) and return
        end
      end
    end
    redirect_to("/workouts/#{params[:workout_id]}")
  end
end
