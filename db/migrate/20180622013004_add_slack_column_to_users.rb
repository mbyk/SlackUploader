class AddSlackColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :slack_access_token, :string
    add_column :users, :slack_user_id, :string
  end
end
