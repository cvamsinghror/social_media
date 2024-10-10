class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:id])
    existing_friendship = current_user.friendships.find_by(friend: friend)

    if existing_friendship
      if existing_friendship.status == 'rejected'
        
        existing_friendship.update(status: 'pending')
        redirect_to users_path, notice: 'Friend request sent again!'
      else
        redirect_to users_path, alert: 'Friend request already sent or already friends.'
      end
    else
      current_user.friendships.create(friend: friend, status: 'pending')
      redirect_to users_path, notice: 'Friend request sent!'
    end
  end

  def update
    friendship = Friendship.find(params[:id])
    if params[:status] == 'accept'
      friendship.update(status: 'accepted')
      redirect_to users_path, notice: 'Friend request accepted!'
    elsif params[:status] == 'reject'
      friendship.update(status: 'rejected')
      redirect_to users_path, notice: 'Friend request rejected.'
    else
      redirect_to users_path, alert: 'Invalid action.'
    end
  end
end