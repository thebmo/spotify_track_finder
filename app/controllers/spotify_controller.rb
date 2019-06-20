include Spotify::Spotify

class SpotifyController < ApplicationController

  # renders the template to auth a user
  def sign_in
  end

  def callback
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @req = request.env['omniauth.auth']
    @playlists = @spotify_user.playlists

    if current_user.present?
      current_user.spotify_user = @spotify_user
      current_user.save!
    end
  end

  def user_playlists
    @user_playlists = current_user.playlists
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
