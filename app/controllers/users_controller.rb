class UsersController < ApplicationController
  before_action :authenticate_user!


  def admin
  
    @admins = User.pending
    @admin_count = @admins.count
  end



  def index
    friends_ids = current_user.friends.pluck(:id) + current_user.inverse_friends.pluck(:id)

    base_query = User.approve.where.not(id: current_user.id)
                     .where.not(id: friends_ids)
                     .or(User.where(id: Friendship.where(friend: current_user, status: 'pending').select(:user_id)))
                     .or(User.where(id: Friendship.where(user: current_user, status: 'pending').select(:friend_id)))

    @q = base_query.ransack(params[:q])
    @users = @q.result(distinct: true)
  end
  
  


  def show
  

    @user = User.find(params[:id])
    @articles = @user.articles


    direct_friends = current_user.friendships.where(status: 'accepted').map(&:friend)
    inverse_friends = current_user.inverse_friendships.where(status: 'accepted').map(&:user)
    
    @friends = direct_friends + inverse_friends
    @friends_count = @friends.count

    @admins = User.pending
    @admin_count = @admins.count
  end


def friends
  @user = User.find(params[:id])

  if @user == current_user

    direct_friends = current_user.friendships.where(status: 'accepted').map(&:friend)
    inverse_friends = current_user.inverse_friendships.where(status: 'accepted').map(&:user)

    @friends = direct_friends + inverse_friends
  else
    redirect_to root_path, alert: "You can only view your own friends list."
  end
end



  def friend_requests
    @pending_friend_requests = current_user.inverse_friendships.where(status: 'pending')
  end



  def approve
    @user = User.find(params[:id])
    if @user.update(approved: "approve")
      redirect_to users_path, notice: 'Article approved successfully.'
    else
      redirect_to admin_users_path, alert: 'Failed to approve the article.'
    end
  end

  def rejected
    @user = User.find(params[:id])
    if @user.update(approved: "rejected")
      redirect_to admin_users_path, notice: 'Article approved successfully.'
    else
      redirect_to admin_users_path, alert: 'Failed to approve the article.'
    end
  end
  
def cancel
end

def pending
  @user = current_user 
  if @user.update(approved: "pending")
    redirect_to drafts_path, notice: 'User status updated to pending.'
  else
    redirect_to cancel_path, alert: 'Failed to update user status.'
  end
end

end
