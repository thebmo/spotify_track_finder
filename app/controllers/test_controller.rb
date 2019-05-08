class TestController < ApplicationController
    def show
        @user = User.find_by_id(params[:id])
	redirect_to users_test_path, :flash => { :error => "id not found!"} if !@user 
    end
    
    def test
	@users = User.all
    end
end
