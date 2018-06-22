class UploadsController < ApplicationController
  def create
    photo = params[:upload][:photo]
    slack_channel_id = params[:upload][:slack_channel_id]

    flash[:success] = "画像をアップロードしました。"
    redirect_to root_url
  end
end
