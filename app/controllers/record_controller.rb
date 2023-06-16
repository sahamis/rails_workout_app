require 'date'

class RecordController < ApplicationController

  def index
    @record_month=Date.strptime(params[:month],"%Y-%m")
    start_date=@record_month.at_beginning_of_month
    end_date=@record_month.at_end_of_month
    @dates=(start_date..end_date).to_a
  end

  def new
    @date=params[:date]
    @workout=Workout.find_by(id:params[:workout_id])
  end

  def create
    @date=Date.parse(params[:date])
    if WorkoutDate.find_by(date:@date)
      @workoutdate=WorkoutDate.find_by(date:@date)
    else
      @workoutdate=WorkoutDate.new(date:@date)
      @workoutdate.save
    end

    for count in 1..5 do
      weight_param=params[:"weight_#{count}"]
      repetitions_param=params[:"repetitions_#{count}"] 
      if weight_param.present? && repetitions_param.present? 
        @set=WorkoutSet.new(
          user_id:@current_user.id,
          workout_id:Workout.find_by(name:params[:workout_name]).id,
          date_id:@workoutdate.id,
          weight:weight_param,
          repetitions:repetitions_param,
          set_count:count
          )
        @set.save
      end
    end
    redirect_to("/record/#{@date}")
  end

  #セットの表示の順番が明示されていないため、要改善
  def show
    @date=Date.strptime(params[:date],"%Y-%m-%d")
    @workout_date=WorkoutDate.find_by(date:@date)
    #指定した日に記録が存在する場合の処理
    if @workout_date
      #その日のセットの記録を取り出す
      @sets_date=WorkoutSet.where(date_id:@workout_date.id)
      #種目idのみを取り出す
      @workout_id=@sets_date.distinct.pluck(:workout_id)
      @workout_sets={}
      @workout_id.each do|workout_id|
        #種目idをキーに持つその種目のセットの配列をバリューとするハッシュを作成
        @workout_sets["workout_#{workout_id}"]=@sets_date.where(workout_id:workout_id)
      end
    else
      @message="種目が登録されていません"
    end
  end

  def choose_workout
    @workouts=Workout.all
    @date=params[:date]
  end

  def edit
    @workout=Workout.find_by(id:params[:workout_id]).name
    @workout_sets=WorkoutSet.where(workout_id:params[:workout_id],date_id:params[:date_id])
  end

  def update
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
          render("record/edit",status: :unprocessable_entity) and return
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
          render("record/edit",status: :unprocessable_entity) and return
        end
      end
    end
    @date=WorkoutDate.find_by(id:params[:date_id]).date
    redirect_to("/record/#{@date}")
  end

  def destroy
    @workout_sets=WorkoutSet.where(workout_id:params[:workout_id],date_id:params[:date_id])
    @workout_sets.destroy_all
    @date=WorkoutDate.find_by(id:params[:date_id]).date
    redirect_to("/record/#{@date}")
  end
end
