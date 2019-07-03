class CreateFollowedArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :followed_artists do |t|
      t.integer :user_id
      t.integer :artist_id
      t.string :artist_remote_id
      t.string :artist_name

      t.timestamps
    end

    add_index :followed_artists, [:user_id, :artist_id], unique: true
  end
end
