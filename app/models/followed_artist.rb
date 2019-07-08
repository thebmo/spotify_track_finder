class FollowedArtist < ApplicationRecord

  # @param artist [Artist] an artist object
  # @param user [User] a user object
  def initialize(artist, user)
    validate_argument!(artist, Artist)
    validate_argument!(user, User)

    super(
      artist_remote_id: artist.remote_id,
      user_id: user.id
      artist_name: artist.name,
      artist_id: artist.id)
  end

  private

  # Raises an ArgumentError if not a RSpotify::Artist object
  #
  # @param argument [Object] an artist object or a user object
  def validate_argument!(argument, klass)
    if !argument || !argument.is_a?(klass)
      raise ArgumentError.new("#{argument.class} given but #{klass} is needed.")
    end
  end
end
