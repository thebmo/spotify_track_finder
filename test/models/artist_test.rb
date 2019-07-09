require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  setup do
    @arcade_fire = Artist.first
  end

  test "should throw an error when not a spotify artist" do
    e = assert_raises(Exception) { Artist.new() }
    assert_equal "spotify_artist most be a RSpotify::Artist object", e.message
  end

  test "should create and persist a new model whith a spotify artist" do
    spotify_artist = create_spotify_artist(__method__)
    a = Artist.create(spotify_artist)
    a.reload

    assert_equal __method__.to_s, a.remote_id
    assert_equal __method__.to_s, a.name
  end

  test "should not allow multiple entries for same artist" do
    e = assert_raises(Exception) { Artist.create(@arcade_fire.spotify_artist) }
    assert e.message.match?(/PG::UniqueViolation/)
  end

  # serialize
  test "jsonify_artist should throw an error when arument is not a spotify artist" do
    e = assert_raises(Exception) { @arcade_fire.jsonify_artist("this will fail") }
    assert_equal "spotify_artist most be a RSpotify::Artist object", e.message
  end

  test "jsonify_artist should return a json string of of the spotify artist" do
    spotify_artist = create_spotify_artist(__method__)
    artist_json = @arcade_fire.jsonify_artist(spotify_artist)

    artist_hash = JSON.parse(artist_json)

    artist_hash.keys.each do |key|
      assert_equal __method__.to_s, artist_hash[key]
    end
  end

  # deserialize
  test "dejsonify_artist should return an RSpotify::Artist with proper attributes" do
    spotify_artist = @arcade_fire.dejsonify_artist
    assert spotify_artist.is_a?(RSpotify::Artist)

    spotify_hash = JSON.parse(@arcade_fire.artist_hash)

    spotify_artist.instance_variables.each do |var|
      assert_equal spotify_hash[var.to_s], spotify_artist.instance_variable_get(var)
    end
  end

  private

  def create_spotify_artist(test_name)
    spotify_artist = RSpotify::Artist.new()
    spotify_artist.instance_variables.each do |var|
      spotify_artist.instance_variable_set(var, test_name)
    end

    spotify_artist
  end
end
