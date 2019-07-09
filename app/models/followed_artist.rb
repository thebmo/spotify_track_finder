class FollowedArtist < ApplicationRecord
  validates :artist_remote_id, :user_id, :artist_name, :artist_id, presence: true

  # @param artist [Artist] an artist object
  # @param user [User] a user object
  def self.create_from_objects(artist, user)
    self.validate_argument!(artist, "Artist")
    self.validate_argument!(user, "User")

    FollowedArtist.create(
      artist_remote_id: artist.remote_id,
      user_id: user.id,
      artist_name: artist.name,
      artist_id: artist.id)
  end

  private

  # Raises an ArgumentError if not a RSpotify::Artist object
  #
  # @param argument [Object] an artist object or a user object
  def self.validate_argument!(argument, klass)
    if !argument || !argument.class.to_s == klass
      raise ArgumentError.new("#{argument.class} given but #{klass} is needed.")
    end
  end
end
