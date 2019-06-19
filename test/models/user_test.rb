require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @password = "Test$1234"
    spu_user = RSpotify::User.new({
      "birthdate"=>nil,
      "country"=>"US",
      "display_name"=>"Test Boi",
      "email"=>"TestBoi@test.com",
      "followers"=>{"href"=>nil, "total"=>29},
      "images"=>
        [{"height"=>nil,
          "url"=>nil,
         "width"=>nil}],
      "product"=>"premium",
      "external_urls"=>{"spotify"=>"https://open.spotify.com/user/sometestid"},
      "href"=>"https://api.spotify.com/v1/users/sometestid",
      "id"=>"sometestid",
      "type"=>"user",
      "uri"=>"spotify:user:sometestid",
      "credentials"=>
      {"token"=>
       "testokenid",
       "refresh_token"=>"testrefreshtokenid",
       "expires_at"=>1560976502,
       "expires"=>true}})

    @user = User.create(
      email: "Test@test.com",
      password: @password,
      spotify_hash: spu_user)
  end

  test "should salt passwords" do
    refute_equal @password, @user.password
  end

  test "should authenticate when given correct password" do
    assert @user.authenticate(@password)
  end

  test "should not authenticate when givien similar passwords" do
    refute @user.authenticate(@password.upcase)
    refute @user.authenticate(@password.downcase)
    refute @user.authenticate("a" + @password)
    refute @user.authenticate(@password +"a")
  end

  test "should build spotify from stored user" do
    spu = @user.spotify_user

    assert_equal RSpotify::User,     spu.class
    assert_equal "testokenid",       spu.credentials["token"]
    assert_equal "TestBoi@test.com", spu.email
  end

  # TODO 6.19.2019: Add spotify hash tests once the change is made

end
