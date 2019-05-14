include Spotify::Spotify

class SpotifyController < ApplicationController
  def list_tracks
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
end
