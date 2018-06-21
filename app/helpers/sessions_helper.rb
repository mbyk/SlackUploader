module SessionsHelper

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

    def log_in(user)
        session[:user_id] = user.id
    end

    def logged_in?
        !@current_user.nil?
    end

    def logout(user)
        user.destroy if logged_in
        reset_session
        redirect_to :root_url
    end
end
