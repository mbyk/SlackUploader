class UploadJobsController < ApplicationController
  include UploadJobsHelper

  def status
    job_id = params[:job_id]
    job = UploadJob.find_by(job_id: job_id)
    if !job
      render json: { status: JobStatus::NONE }
    elsif job.success?
      render json: { result: JobStatus::SUCCESS }
    elsif job.error?
      render json: { result: JobStatus::ERROR }
    else
      render json: { result: JobStatus::PROGRESS }
    end

  end
end
