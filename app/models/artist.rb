class Artist < ApplicationRecord

  # @param spotify_artist [RSpotify::Artist] an artist object
  def initialize(spotify_artist)
    remote_id = spotify_artist.id
    name = spotify_artist.name
    artist_hash = jsonify_artist(spotify_artist)
    super(remote_id: remote_id, name: name, artist_hash: artist_hash)
  end

  # @returns an [RSpotify::Artist] object
  def spotify_artist
    @spotify_artist ||= dejsonify_artist
  end

  # serializes the spotify artist object as json string
  #
  # @param spotify_artist [RSpotify::Artist] an artist object
  def jsonify_artist(spotify_artist)
    h = {}
    spotify_artist.instance_variables.each do |var|
      h[var] = spotify_artist.instance_variable_get(var)
    end

    h.to_json
  end

  # @return [RSpotify::Artist] from the models cache
  def dejsonify_artist
    artist = RSpotify::Artist.new()
    JSON.parse(self.artist_hash).each do |k, v|
      artist.instance_variable_set(k, v)
    end

    artist
  end
end
