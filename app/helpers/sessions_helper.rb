module SessionsHelper

    def slack_state
        session[:slack_state] ||= SecureRandom.urlsafe_base64
    end

    def reset_slack_state
        session.delete(:slack_state)
    end

    def is_slack_linked?
        !!current_user&.slack_access_token
    end

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

    def log_in(user)
        session[:user_id] = user.id
    end

    def logged_in?
        !current_user.nil?
    end

    def logout
        reset_session
    end
end
