class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    following = current_user.relationships.build(follower_id: params[:user_id])
    # following_idにはcurrent_user.idが入る
    # followerにはパラメーターから取ってきたuser_idが入る
    following.save
  end

  def destroy
    @user = User.find(params[:user_id])
    following = current_user.relationships.find_by(follower_id: params[:user_id])
    # following_idにはcurrent_user.idが入る
    # followerにはパラメーターから取ってきたuser_idが入る
    following.destroy
  end
end
