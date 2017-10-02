require 'test_helper'

class TrendingUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get trending_users_index_url
    assert_response :success
  end

end
