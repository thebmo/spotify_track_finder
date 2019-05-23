class UpdateUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password, :string
    add_column :users, :remote_id, :string
    add_column :users, :spotify_hash, :json
    add_index :users, :remote_id, unique: true
  end
end
