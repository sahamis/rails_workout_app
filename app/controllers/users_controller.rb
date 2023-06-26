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
