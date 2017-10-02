class TrendingUsersController < ApplicationController
  def index
    # Simple way
    # @users = User.left_joins(:followers).group('users.id').order('count(followers.follower_id) DESC').limit(10)

    # Lambda way
    @users = User.trending_users
  end
end
