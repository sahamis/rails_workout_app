require "date"

class ApplicationController < ActionController::Base
  before_action :set_current_user
  before_action :get_today

  def set_current_user
    @current_user=User.find_by(id:session[:user_id])
  end

  def authenticate_user
    if @current_user==nil
      flash[:notice]="ログインが必要です"
      redirect_to("/login")
    end
  end

  def forbid_login_user
    if @current_user
      flash[:notice]="すでにログインしています"
      redirect_to("/record/index/#{@this_month}")
    end
  end

  def get_today
    @today=Date.today
    @this_month=@today.strftime("%Y-%m")
  end
end
