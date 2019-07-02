class CreateFollowedArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :followed_artists do |t|

      t.timestamps
    end
  end
end
