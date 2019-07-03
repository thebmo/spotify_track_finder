class FollowedArtist < ApplicationRecord

  # @param artist [Artist] an artist object
  # @param user [User] a user object
  def initialize(artist)
    validate_artist!(artist)

    # TODO 7.3.2019: DRY THIS UP
    if !user || !user.is_a?(User)
      raise ArgumentError.new("user must be provided")
    end

    # TODO 7.3.2019 clean this shit up
    artist_remote_id = artist.remote_id
    user_id = user.id
    artist_id = artist.id
    artist_name = artist.name
    super(
      artist_remote_id: artist_remote_id,
      user_id: user_id
      artist_name: artist_name,
      artist_id: artist_id)
  end

  # Raises an ArgumentError if not a RSpotify::Artist object
  #
  # @param artist [Artist] an artist object
  def validate_artist!(artist)
    if !artist || !artist.is_a?(Artist)
      raise ArgumentError.new("artist most be an Artist object")
    end
  end
end
