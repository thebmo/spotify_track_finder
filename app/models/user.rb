class User < ApplicationRecord
  include Spotify::Spotify

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

  # FOLLOW METHODS
  # FINSIH THIS WHERE CLAUSE
  def followed_artists
    @followed_artists ||= FollowedArtist.where(:user_id => self.id)
  end

  def follow_artist!(spotify_artist)
    artist = Artist.find_by(:remote_id => spotify_artist.id) || Artist.create(spotify_artist)
    followed_artist = FollowedArtist.find_by(:user_id => self.id, :artist_id => artist.id)
    followed_artist ||= FollowedArtist.create_from_objects(artist, self)
  end

  def unfollow_artist!(spotify_artist)
    followed_artist = FollowedArtist.find_by(:user_id => self.id, :artist_id => artist.id)
     @followed_artists.delete(followed_artist) if followed_artist
    followed_artist.destroy
  end


  # INTERFACE METHODS

  def playlists(limit: 20, offset: 0)
    retry_for_user(:playlists, [{ limit: limit, offset: offset }])
  end

  def create_playlist!(name, public: true)
    retry_for_user(:create_playlist!, [name, { public: true }])
  end

  def recently_played(limit: 20)
    retry_for_user(:recently_played, [{ limit: limit }])
  end

  def saved_tracks(limit: 20, offset: 0)
    retry_for_user(:saved_tracks, [{ limit: limit, offset: offset }])
  end

  private

  # delagates the passed in method and arguments to spotify
  # user model whil forcing up to 3 retries of re authentication
  #
  # @param method [Symbol] the method we want to execute
  # @param args [Array] positional, then keyword argmuments of the parent method.
  def retry_for_user(method, args)
    attempt = 0
    max_retries = 3

    begin
      spotify_user.send(method, *args)
    rescue => e
      if e.message.match?(/bad request/i) && attempt < max_retries
        attempt+=1

        re_auth_user!(self)

        @spotify_user = nil
        self.reload

        retry
      end

      raise e
    end
  end
end
