class UsersController < ApplicationController
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
    redirect_to("/record/index")
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
      redirect_to("/record/index")
    else
      render("users/login_form",status: :unprocessable_entity)
    end
  end
end
