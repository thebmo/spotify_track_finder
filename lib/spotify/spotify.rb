# lib/spotify/spotify.rb
require 'rspotify'

module Spotify::Spotify
  # SCOPES: see "config/initializers/omniauth.rb"
  REGION = "US".freeze
  LIMIT  = 50.freeze

  CLIENT_ID = ENV['SPOTIFY_CLIENT_ID'].freeze
  CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET'].freeze


  RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)

  # @TODO 5.25.2019 needs to filter by artist id
  # @param band_name [String] the band name as a string
  # @return [Hash<<Symbol, Track>] a hash of track objects by id
  def find_all_tracks(band_name)
    artist = RSpotify::Artist.search(band_name).first;

    return [] if !artist

    all_albums = resources_for_object(artist, :albums)
    all_tracks = []

    all_albums.each do |album|
      # skip compilation albums
      next if album.artists.map(&:name).include?("Various Artists")
      all_tracks += resources_for_object(album, :tracks)
    end

    return all_tracks
  end

  def create_playlist
  end

  # @param tracks [Hash<Symbol,Track>] a hash of track objects by id
  # @param playlist [Playlist] a playlist object
  def add_tracks_to_playlist(tracks, playlist)
  end

  # updates a user objects spotify hash with a new acces token
  # @param user [ActiveRecord::User]
  # @return [Boolean] true if user is saved, false otherwise
  def re_auth_user!(user)
    raise ArgumentError("User must be an active record model, not spotify user") if !user.is_a?(User)

    spotify_user = user.spotify_user
    refresh_token = spotify_user.credentials["refresh_token"]
    spotify_user.credentials["token"] = refresh_access_token(refresh_token)
    spotify_user.credentials["expires_at"] = Time.now.to_i + 3600
    user.spotify_user = spotify_user

    user.save!
  end

  private

  # requests a refresh for users access token
  #
  # @param refresh_token [String] a users spotify refresh token
  # @return [String] a users spotify access token
  def refresh_access_token(refresh_token)
    response = Faraday.post(
      'https://accounts.spotify.com/api/token',
      {
        'client_id' => CLIENT_ID,
        'client_secret' => CLIENT_SECRET,
        'grant_type' => 'refresh_token',
        'refresh_token' => refresh_token })

    acess_token = JSON.parse(response.body)["access_token"]
  end

  # returns an array of requested type resource objects for a given object
  # ex: resources_for_object(album, :tracks) => returns [Array<Tracks>]
  #
  # @param obj           [Object] the class object to request resource for
  # @param resource_type [Symbol] the type of resource we want to request as a symbol
  # @return all_recouces [Array<Objects>] an array of the requested resource objects
  def resources_for_object(obj, resource_type)
    all_resources = []

    kwargs = {
      limit: LIMIT,
      offset: 0
    }

    kwargs[:country] = REGION if resource_type == :albums

    loop do
      current_resources = obj.send(resource_type, kwargs)
      all_resources += current_resources
      current_resource_count = current_resources.count
      kwargs[:offset] += current_resource_count
      break if current_resource_count < LIMIT
    end

    return all_resources
  end
end
