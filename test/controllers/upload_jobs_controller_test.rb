require 'test_helper'

class UploadJobsControllerTest < ActionDispatch::IntegrationTest
  test "should get status" do
    get upload_jobs_status_url
    assert_response :success
  end

end
