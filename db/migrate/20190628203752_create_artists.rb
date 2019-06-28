class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.string :remote_id
      t.string :name
      t.json :artist_hash

      t.timestamps
    end

    add_index :artists, :remote_id, unique: true
    add_index :artists, :name, unique: true
  end
end
