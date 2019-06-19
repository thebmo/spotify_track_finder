class User < ApplicationRecord
  attr_reader :spotify_user

  def initialize(*args)
    args.first[:email] = args.first[:email].downcase

    # generate and add salt to model arguments
    salt = BCrypt::Engine.generate_salt
    args.first[:salt] = salt

    # create new salted and hashed password
    password = BCrypt::Engine.hash_secret(args.first[:password], salt)
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
    BCrypt::Engine.hash_secret(given_password, self.salt) == self.password
  end
end
