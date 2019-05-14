# lib/spotify/spotify.rb
require 'rspotify'

module Spotify::Spotify
  REGION = "US".freeze
  SCOPES = 'user-read-private user-read-email'
  CLIENT_ID = ENV['SPOTIFY_CLIENT_ID'].freeze
  CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET'].freeze

  RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)

  # to find all spotify artist tracks
  # this needs to filter by artist id
  # this seems to limit by 20a
  # @param band_name [String] the band name as a string
  # @return [Hash<<Symbol, Track>] a hash of track objects by id
  def find_all_tracks(band_name)
    all_band_tracks = {}
    artist = RSpotify::Artist.search(band_name).first;
    albums = (RSpotify::Base.search(band_name, "album") + artist.albums) #this finds dupes

    albums.each do |album|
      #available_markets = Hash[album.available_markets.collect { |k| [k,'']}]
      #next if REGION and !available_markets[REGION]

      album.tracks.each do |track|
        all_band_tracks[track.id] = track if !all_band_tracks[track.id]
      end
    end

    all_band_tracks
  end

  def create_playlist
  end

  # @param tracks [Hash<Symbol,Track>] a hash of track objects by id
  # @param playlist [Playlist] a playlist object
  def add_tracks_to_playlist(tracks, playlist)
  end
end
