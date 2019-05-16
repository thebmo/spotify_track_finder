# lib/spotify/spotify.rb
require 'rspotify'

module Spotify::Spotify
  REGION = "US".freeze
  SCOPES = 'user-read-private user-read-email'
  LIMIT  = 50.freeze

  CLIENT_ID = ENV['SPOTIFY_CLIENT_ID'].freeze
  CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET'].freeze


  RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)

  # to find all spotify artist tracks
  # this needs to filter by artist id
  # this seems to limit by 20a
  # @param band_name [String] the band name as a string
  # @return [Hash<<Symbol, Track>] a hash of track objects by id
  def find_all_tracks(band_name)
    artist = RSpotify::Artist.search(band_name).first;

    return [] if !artist

    all_albums = resources_for_object(artist, :albums)
    all_tracks = []

    all_albums.each do |album|
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

  private

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
