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

  def spotify_user
    @spotify_user ||= RSpotify::User.new(spotify_hash)
  end

  def spotify_user=(spotify_user)
    spu_json = spotify_user.to_hash.to_json
    self.spotify_hash = spu_json
  end

  def spotify_hash
    JSON.parse(self[:spotify_hash])
  end

  def authenticate(given_password)
    BCrypt::Engine.hash_secret(given_password, self.salt) == self.password
  end

  # INTERFACE
  def playlists(limt: 20, offset: 0)
    spotify_user.playlists(limit: limit, offeset: offset)
  end

  def create_playlist!(name, public: true)
    spotify_user.create_playist(name, public: public)
  end

  def recently_played(limit: 20)
    spotify_user.recently_played(limit: limit)
  end

  def saved_tracks(limit: 20, offset: 0)
    spotify_user.saved_tracks(limit: limit, offset: offset)
  end
end
