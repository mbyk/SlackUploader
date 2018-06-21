class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && !!user.authenticate(params[:session][:password])
      flash[:success] = "ログインしました"
      log_in user
      redirect_to root_url and return
    else
      flash.now[:error] = "ログインできませんでした。"
      render 'new'
    end
  end

  def destroy
    logout
    flash[:success] = "ログアウトしました"
    redirect_to root_url
  end
end
