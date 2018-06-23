require 'net/http/post/multipart'

class UploadsController < ApplicationController

  def create
    photo = params[:upload][:photo]
    slack_channel_id = params[:upload][:slack_channel_id]

   if photo.nil?
      flash[:error] = "画像を指定してください"
      redirect_to root_url and return
    end 

    content_type = photo.content_type
    original_filename = photo.original_filename
    tempfile = photo.tempfile

    if send_request(tempfile, original_filename, content_type, slack_channel_id)
      flash[:success] = "画像をアップロードしました。"
      redirect_to root_url
    else
      flash[:error] = "画像をアップロードできませんでした。"
      redirect_to root_url
    end

  end

  private

    # Request (POST )
    def send_request(file, filename, content_type, channel_id)
      puts "requeset url: #{EasySettings.slack.file_upload_url}"
      uri = URI(EasySettings.slack.file_upload_url)

      # Create client
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      body = {
        "token" => User.slack_token_decrypt(current_user.slack_access_token),
        "channels" => channel_id,
        "file" => UploadIO.new(file, content_type, filename)
      }
    
      # Create Request
      req =  Net::HTTP::Post::Multipart.new(uri, body)

      # Add headers
      req.add_field "Content-Type", "multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__"
    
      # Fetch Request
      res = http.request(req)
      puts "Response HTTP Status Code: #{res.code}"
      puts "Response HTTP Response Body: #{res.body}"
      json = JSON.parse(res.body)
      return json['ok'] == true

     rescue StandardError => e
       puts "HTTP Request failed (#{e.message})"
       return false
     end

end
