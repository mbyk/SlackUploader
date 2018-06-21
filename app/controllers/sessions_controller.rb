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

  def slack_oauth
    query = {
       client_id: '352542358647.384827545504',
       scope: 'files:write:user',
       redirect_url: 'http://lvh.me:3000/slack/oauth/callback',
       state: slack_state
      }
    redirect_to "https://slack.com/oauth/authorize?#{query.to_query}"
  end

  def slack_oauth_callback
    session_slack_state = session[:slack_state]
    reset_session
    if params[:slack_state] == session_slack_state
      # success
      code = params[:code]
      

    else
      # error
      flash[:error] = 'Slack連携できませんでした。'
      redirect_to root_url
    end
  end
end
