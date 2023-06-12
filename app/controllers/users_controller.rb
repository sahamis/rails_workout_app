class UsersController < ApplicationController
  before_action :get_today ,{only:[:create,:login,:logout]}

  def new
  end

  def create
    @user=User.new(
      name:params[:name],
      email:params[:email],
      password:params[:password]
    )
    @user.save
    session[:user_id]=@user.id
    redirect_to("/record/index/#{@this_month}")
  end

  def login_form
  end

  def login
    @user=User.find_by(
      email:params[:email],
      password:params[:password]
    )
    if @user
      session[:user_id]=@user.id
      redirect_to("/record/index/#{@this_month}")
    else
      render("users/login_form",status: :unprocessable_entity)
    end
  end

  def logout
    session[:user_id]=nil
    redirect_to("/record/index/#{@this_month}")
  end
end
