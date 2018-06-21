class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params) 
        if @user.save
            log_in @user
            flash[:success] = "登録しました。"
            redirect_to root_path and return
        else
            flash.now[:error] = "登録に失敗しました。"
            render 'new'
        end
    end

    private

        def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
end
