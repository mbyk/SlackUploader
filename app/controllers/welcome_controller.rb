class WelcomeController < ApplicationController

  def home
    if logged_in? && is_slack_linked?
      @slack_channel_list = send_channel_request
    end
  end

  private

  # Request (GET )
  def send_channel_request
    uri = URI("#{EasySettings.slack.channel_list_url}?token=#{User.slack_token_decrypt(current_user.slack_access_token)}")

    # Create client
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    # Create Request
    req =  Net::HTTP::Get.new(uri)

    # Fetch Request
    res = http.request(req)
    puts "Response HTTP Status Code: #{res.code}"
    puts "Response HTTP Response Body: #{res.body}"
    json = JSON.parse(res.body)
    if json['ok'] == true
      return json['channels'].map { |c| SlackChannel.new(c) }
    end

  rescue StandardError => e
    puts "HTTP Request failed (#{e.message})"
  end

end

