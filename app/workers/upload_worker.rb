class UploadWorker
  include Sidekiq::Worker

  def perform(data)
    Rails.logger.debug("*#{data}*")
  end
end
