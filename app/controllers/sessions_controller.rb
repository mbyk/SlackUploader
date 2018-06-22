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
       client_id: EasySettings.slack.client_id,
       scope: EasySettings.slack.scope,
       redirect_url: EasySettings.slack.oauth_redirect_url,
       state: slack_state
      }
    redirect_to "#{EasySettings.slack.authorize_url}?#{query.to_query}"
  end

  def slack_oauth_callback
    session_slack_state = session[:slack_state]
    if params[:state] == session_slack_state
      reset_slack_state
      # success
      code = params[:code]

      begin
        params = URI.encode_www_form({ 
          client_id: EasySettings.slack.client_id,
          client_secret: EasySettings.slack.client_secret,
          code: code 
        })

        uri = URI(EasySettings.slack.oauth_access_url)
        uri.query = params
        res = Net::HTTP.get_response(uri)

        data = JSON.parse(res.body)
        access_token = data[:access_token.to_s]
        user_id = data[:user_id.to_s]

        update_params = { slack_access_token: access_token, slack_user_id: user_id }
        if current_user.update(update_params) 
          flash[:success] = "Slackを連携しました。"
          redirect_to root_url and return
        end

      rescue Exception => e
      end
    end

    # error
    reset_slack_state
    flash[:error] = 'Slack連携できませんでした。'
    redirect_to root_url
  end
end
