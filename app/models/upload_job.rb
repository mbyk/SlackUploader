class UploadJob < ApplicationRecord
  belongs_to :user

  enum status: { progress: 0, error: 1, success: 2 }

end
