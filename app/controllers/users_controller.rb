class UsersController < ApplicationController
  before_action :authenticate_user, {only:[:logout,:index,:show,:edit,:update,:destroy]}
  before_action :forbid_login_user, {only:[:new,:create,:login_form,:login]}
  before_action :ensure_correct_user, {only:[:edit,:update,:destroy]}

  def ensure_correct_user
    unless @current_user.id == params[:user_id].to_i
      flash[:notice]="権限がありません"
      redirect_to("/record/index/#{@this_month}")
    end
  end

  def new
    @user=User.new
  end

  def create
    @user=User.new(
      name:params[:name],
      email:params[:email],
      password:params[:password]
    )
    if @user.save
      session[:user_id]=@user.id
      flash[:notice]="会員登録が完了しました"
      redirect_to("/record/index/#{@this_month}")
    else
      render("users/new",status: :unprocessable_entity)
    end
  end

  def login_form
    @user=User.new
  end

  def login
    @user=User.find_by(email:params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id]=@user.id
      flash[:notice]="ログインしました"
      redirect_to("/record/index/#{@this_month}")
    else
      @error_message="メールアドレスまたはパスワードが間違っています"
      render("users/login_form",status: :unprocessable_entity)
    end
  end

  def logout
    session[:user_id]=nil
    flash[:notice]="ログアウトしました"
    redirect_to("/login")
  end

  def index
    @users=User.all
  end

  def show
    @user=User.find_by(id:params[:user_id])
    #記録を登録された順番で取り出し、登録された順番のworkout_idとdate_idを取得
    workout_sets=WorkoutSet.where(user_id:@user.id).order(id:"DESC")
    recent_workouts_date = workout_sets.group(:id, :date_id).limit(25).pluck(:date_id)
    recent_workouts_workout = workout_sets.group(:id, :workout_id).limit(25).pluck(:workout_id)
    recent_workouts_ids=[]
    for n in 0 ..(recent_workouts_date.length-1) do
      recent_workouts_ids.push([recent_workouts_date[n],recent_workouts_workout[n]])
    end
    recent_workouts_id=recent_workouts_ids.uniq
    puts recent_workouts_id
    #recent_workouts_setsに登録された順番のセットを種目分けで格納
    @recent_workouts_sets=[]
    for count in 0..(recent_workouts_id.length-1) do
      @recent_workouts_sets.push(WorkoutSet.where(workout_id: recent_workouts_id[count][0],
        date_id: recent_workouts_id[count][1])
      )
    end
  end

  def edit
    @user=User.find_by(id:params[:user_id])
  end

  def update
    @user=User.find_by(id:params[:user_id])
    @user.name=params[:name]
    @user.email=params[:email]
    if @user.save
      flash[:notice]="編集内容を登録しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit",status: :unprocessable_entity)
    end
  end

  def destroy
    @user=User.find_by(id:params[:user_id])
    @user.destroy
    flash[:notice]="ユーザー情報を削除しました"
    redirect_to("/login")
  end
end
