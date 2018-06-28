class CreateUploadJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :upload_jobs do |t|
      t.references :user, foreign_key: true
      t.string :job_id, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

		add_index :upload_jobs, :job_id
		add_index :upload_jobs, [:user_id, :job_id]
  end
end
