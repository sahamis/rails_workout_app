class WorkoutsController < ApplicationController
  def new
    @category=Category.find_by(id:params[:category_id])
  end

  def create
    @workout=Workout.new(
      name:params[:name],
      category_id:Category.find_by(name:params[:category_name]).id)
    @workout.save
    flash[:notice]="新規種目を登録しました"
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
    flash[:notice]="編集内容を登録しました"
    redirect_to("/workouts/#{@workout.id}")
  end

  def sets_edit
    @date=WorkoutDate.find_by(id:params[:date_id])
    @workout=Workout.find_by(id:params[:workout_id])
    @workout_sets=WorkoutSet.where(date_id:params[:date_id],workout_id:params[:workout_id])
  end

  def sets_update
    @date=WorkoutDate.find_by(id:params[:date_id])
    @workout=Workout.find_by(id:params[:workout_id])
    @workout_sets=WorkoutSet.where(date_id:@date.id,workout_id:@workout.id)
    
    #１セット目のパラメータに入力がなかったときの処理
    unless params[:weight_0].present? && params[:repetitions_0].present?
      @error_message="1セット目は必ず入力してください"
      render("workouts/sets_edit",status: :unprocessable_entity) and return
    end

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
          @error_message="重量と回数の両方を入力してください"
          render("workouts/sets_edit",status: :unprocessable_entity) and return
        else 
          #空欄だったフィールド以降のフィールドに入力があるか確認している
          for count_p in (count+1)..4 do
            if params[:"weight_#{count_p}"].present? || params[:"repetitions_#{count_p}"].present?
              @error_message="空欄のセット以降に値を入力しないでください"
              render("workouts/sets_edit",status: :unprocessable_entity) and return
            end
          end
          @workout_sets[count..4].each do|workout_set_p|
            if workout_set_p.present?
              workout_set_p.destroy
            end
          end
          flash[:notice]="編集内容を登録しました"
          redirect_to("/workouts/#{params[:workout_id]}") and return
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
          @error="重量と回数の両方を入力してください"
          render("workouts/sets_edit",status: :unprocessable_entity) and return
        else
          #空欄だったフィールド以降のフィールドに入力があるか確認している
          for count_p in (count+1)..4 do
            if params[:"weight_#{count_p}"].present? || params[:"repetitions_#{count_p}"].present?
              @error_message="空欄のセット以降に値を入力しないでください"
              render("record/edit",status: :unprocessable_entity) and return
            end
          end
          flash[:notice]="編集内容を登録しました"
          redirect_to("/workouts/#{params[:workout_id]}") and return
        end
      end
    end
    flash[:notice]="編集内容を登録しました"
    redirect_to("/workouts/#{params[:workout_id]}")
  end
end
