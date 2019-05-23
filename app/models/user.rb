class User < ApplicationRecord
  attr_reader :spotify_user


  def spotify_hash=(spotify_user)
    spu_json = spotify_user.to_hash.to_json
    super(spu_json)
  end

  def spotify_hash
    JSON.parse(self[:spotify_hash])
  end

  def spotify_user
    @spotify_user ||= RSpotify::User.new(spotify_hash)
  end
end
