require 'rspotify'

class SpotifyController < ApplicationController
  def list_tracks
    client_id = ENV['SPOTIFY_CLIENT_ID']
    client_secret = ENV['SPOTIFY_CLIENT_SECRET']
    scopes = 'user-read-private user-read-email'

    RSpotify.authenticate(client_id, client_secret)

    if !!params[:band_name]
      band_name = params[:band_name].titleize
    else
      band_name = "Arcade Fire"
    end

    @tracks = find_all_tracks(band_name)

    respond_to do |format|
      format.html
      format.json do
        render json: @tracks.to_json
      end
    end
  end

  private

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

end
