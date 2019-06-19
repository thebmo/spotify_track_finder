class User < ApplicationRecord
  attr_reader :spotify_user

  def initialize(*args)
    args.first[:email] = args.first[:email].downcase

    # generate and add salt to model arguemns
    salt = SecureRandom.hex(32)
    args.first[:salt] = salt

    # create new salted and hashed password
    password = BCrypt::Password.create(salt + args.first[:password]).to_s
    args.first[:password] = password

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

  def authenticate(given_password)
    BCrypt::Password.new(self.password) == self.salt + given_password
  end
end
