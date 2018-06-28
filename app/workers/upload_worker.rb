require 'net/http/post/multipart'

class UploadWorker
  include Sidekiq::Worker

  def perform(data)
    current_user = User.find(data[:current_user_id.to_s])
    job = current_user.upload_jobs.create(job_id: self.jid)

    res = send_request(data[:temp_path.to_s], data[:filename.to_s], data[:content_type.to_s], data[:channel_id.to_s], data[:current_user_id.to_s])
    if res[:result]
      job.update_attribute("status", 2)
    else
      job.update_attribute("status", 1)
    end
  end

  private

      # Request (POST )
      def send_request(temp_path, filename, content_type, channel_id, current_user_id)
        current_user = User.find(current_user_id)

        puts "requeset url: #{EasySettings.slack.file_upload_url}"
        uri = URI(EasySettings.slack.file_upload_url)
  
        # Create client
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        File.open(temp_path) do |file|
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
          return {
            result: true,
            permalink: json['file']['permalink']
          }
  
        end
  
 
      rescue StandardError => e
         puts "HTTP Request failed (#{e.message})"
         return {
           result: false
         }
      end
end
