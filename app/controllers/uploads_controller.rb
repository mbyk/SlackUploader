require 'net/http/post/multipart'

class UploadsController < ApplicationController

  include Base64ToFile

  before_action :check_upload_file

  def create
    slack_channel_id = params[:upload][:slack_channel_id]

   if @upload_photo.nil?
      flash[:error] = "画像を指定してください"
      redirect_to root_url and return
    end 

    content_type = @upload_photo.content_type
    original_filename = @upload_photo.original_filename
    tempfile = @upload_photo.tempfile

    status_check_job_id = UploadWorker.perform_async({temp_path: tempfile.path, filename: original_filename, content_type: content_type, channel_id: slack_channel_id, current_user_id: current_user.id})
    session[:status_check_job_id] = status_check_job_id
    redirect_to root_url

    # if result[:result]
    #   flash[:success] = "画像をアップロードしました。<div><a href='#{result[:permalink]}'>#{result[:permalink]}</a></div>"
    #   redirect_to root_url
    # else
    #   flash[:error] = "画像をアップロードできませんでした。"
    #   redirect_to root_url
    # end

  end

  private

    def check_upload_file
      photo = params[:upload][:photo]
      drop_photo = params[:upload][:drop_photo];

      if !photo.nil?
        # input[type=file]
        @upload_photo = photo
      elsif !drop_photo.blank?
        # base64 decode
        @upload_photo = base64_to_file(drop_photo)
      else
        @upload_photo = nil
      end

      @upload_photo
    end

end
