require 'date'

class RecordController < ApplicationController
  before_action :authenticate_user 

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
    @workout=Workout.find_by(name:params[:workout_name])
    #ワークアウトが選択されてなかったときの処理
    unless Workout.find_by(name:params[:workout_name])
      @error_message="種目が選択されていません"
      render("record/new",status: :unprocessable_entity) and return
    end
    #１セット目のパラメータに入力がなかったときの処理
    unless params[:weight_1].present? && params[:repetitions_1].present?
      @error_message="1セット目は必ず入力してください"
      render("record/new",status: :unprocessable_entity) and return
    end
    #日付のworkoutdateモデル内での存在の有無で処理を分岐
    if WorkoutDate.find_by(date:@date)
      @workoutdate=WorkoutDate.find_by(date:@date)
    else
      @workoutdate=WorkoutDate.new(date:@date)
      @workoutdate.save
    end

    for count in 1..5 do
      weight_param=params[:"weight_#{count}"]
      repetitions_param=params[:"repetitions_#{count}"] 
      #weightフィールドとrepetitionsフィールドの両方に入力がある場合のみモデルを作成
      if weight_param.present? && repetitions_param.present? 
        @set=WorkoutSet.new(
          user_id:@current_user.id,
          workout_id:@workout.id,
          date_id:@workoutdate.id,
          weight:weight_param,
          repetitions:repetitions_param,
          set_count:count
          )
        @set.save
      elsif weight_param.present? || repetitions_param.present? 
        @error_message="重量と回数の両方を入力してください"
        render("record/new",status: :unprocessable_entity) and return
      else 
        #空欄だったフィールド以降のフィールドに入力があるか確認している
        for count_p in (count+1)..5 do
          if params[:"weight_#{count_p}"].present? || params[:"repetitions_#{count_p}"].present?
            @error_message="空欄のセット以降に値を入力しないでください"
            render("record/new",status: :unprocessable_entity) and return
          end
        end
        flash[:notice]="記録が登録されました"
        redirect_to("/record/#{@date}") and return
      end
    end
    flash[:notice]="記録が登録されました"
    redirect_to("/record/#{@date}")
  end

  #セットの表示の順番が明示されていないため、要改善
  def show
    @date=Date.strptime(params[:date],"%Y-%m-%d")
    @workout_date=WorkoutDate.find_by(date:@date)
    #指定した日に記録が存在する場合の処理
    if @workout_date
      #その日のセットの記録を取り出す
      @sets_date=WorkoutSet.where(date_id:@workout_date.id,user_id:@current_user.id)
      #workout_dateが存在し、workout_setが存在しない場合の処理
      unless @sets_date.present?
        @error_message="記録が登録されていません"
      end
      #種目idのみを取り出す
      @workout_id=@sets_date.distinct.pluck(:workout_id)
      @workout_sets={}
      @workout_id.each do|workout_id|
        #種目idをキーに持つその種目のセットの配列をバリューとするハッシュを作成
        @workout_sets["workout_#{workout_id}"]=@sets_date.where(workout_id:workout_id)
      end
    else
      @error_message="記録が登録されていません"
    end
  end

  def choose_workout
    @workouts=Workout.where(user_id:@current_user.id)
    @date=params[:date]
    unless @workouts.present?
      @error_message="種目が登録されていません"
    end
  end

  def edit
    @workout=Workout.find_by(id:params[:workout_id]).name
    @workout_sets=WorkoutSet.where(workout_id:params[:workout_id],date_id:params[:date_id])
  end

  def update
    @date=WorkoutDate.find_by(id:params[:date_id]).date
    @workout_sets=WorkoutSet.where(workout_id:params[:workout_id],date_id:params[:date_id])
    #１セット目のパラメータに入力がなかったときの処理
    unless params[:weight_0].present? || params[:repetitions_0].present?
      @error_message="1セット目は必ず入力してください"
      render("record/edit",status: :unprocessable_entity) and return
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
          render("record/edit",status: :unprocessable_entity) and return
        else 
          #空欄だったフィールド以降のフィールドに入力があるか確認している
          for count_p in (count+1)..4 do
            if params[:"weight_#{count_p}"].present? || params[:"repetitions_#{count_p}"].present?
              @error_message="空欄のセット以降に値を入力しないでください"
              render("record/edit",status: :unprocessable_entity) and return
            end
          end
          @workout_sets[count..4].each do|workout_set_p|
            if workout_set_p.present?
              workout_set_p.destroy
            end
          end
          flash[:notice]="編集内容を登録しました"
          redirect_to("/record/#{@date}") and return
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
          @error_message="重量と回数の両方を入力してください"
          render("record/edit",status: :unprocessable_entity) and return
        else
          #空欄だったフィールド以降のフィールドに入力があるか確認している
          for count_p in (count+1)..4 do
            if params[:"weight_#{count_p}"].present? || params[:"repetitions_#{count_p}"].present?
              @error_message="空欄のセット以降に値を入力しないでください"
              render("record/edit",status: :unprocessable_entity) and return
            end
          end
          flash[:notice]="編集内容を登録しました"
          redirect_to("/record/#{@date}") and return
        end
      end
    end
    flash[:notice]="編集内容を登録しました"
    redirect_to("/record/#{@date}")
  end

  def destroy
    @workout_sets=WorkoutSet.where(workout_id:params[:workout_id],date_id:params[:date_id])
    @workout_sets.destroy_all
    @date=WorkoutDate.find_by(id:params[:date_id]).date
    flash[:notice]="記録を削除しました"
    redirect_to("/record/#{@date}")
  end
end
