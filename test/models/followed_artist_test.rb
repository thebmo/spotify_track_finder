require 'test_helper'

class FollowedArtistTest < ActiveSupport::TestCase
  setup do
    @user = User.first
    @artist = Artist.first
  end


  test "should raise with no arguments" do
    e = assert_raises(Exception) { FollowedArtist.create_from_objects() }
    assert_equal "wrong number of arguments (given 0, expected 2)", e.message
  end

  test "should raise with just artist" do
    e = assert_raises(Exception) { FollowedArtist.create_from_objects(@artist, nil) }
    assert_equal "NilClass given but User is needed.", e.message
  end

  test "should raise with just user" do
    e = assert_raises(Exception) { FollowedArtist.create_from_objects(nil, @user) }
    assert_equal "NilClass given but Artist is needed.", e.message
  end

  test "should require pair uniquness" do
    FollowedArtist.create_from_objects(@artist, @user)
    e = assert_raises(Exception) { FollowedArtist.create_from_objects(@artist, @user) }
    assert e.message.match?(/PG::UniqueViolation/)
  end
end
