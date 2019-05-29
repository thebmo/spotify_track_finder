include Spotify::Spotify

class SpotifyController < ApplicationController

  # renders the template to auth a user
  def sign_in
  end

  def callback
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @req = request.env['omniauth.auth']
    @playlists = @spotify_user.playlists

    if session[:current_user].present?
      session[:current_user].spotify_hash = @spotify_user
    end
  end

  def user_playlists
  end

  def playlist
  end

  def band_tracks
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
