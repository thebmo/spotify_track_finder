class User < ApplicationRecord
  attr_reader :spotify_user

  def initialize(*args)
    args.first[:email] = args.first[:email].downcase
    # TODO 6.17.2019: Salt Passwords on Creation:
    super(*args)
  end

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

  # TODO 6.4.2019: add salt hashing
  def authenticate(given_password)
    given_password == self.password
  end
end
