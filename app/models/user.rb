class User < ApplicationRecord
  acts_as_voter
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :friendships
  has_many :friends, through: :friendships, source: :friend

  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user


 
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



         enum approved: { approve: 0, pending: 1, rejected: 2 }


  def self.ransackable_attributes(auth_object = nil)
    ["first_name", "last_name", "email", "address"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end



  # Additional helper methods
 
 
  def friends_with?(other_user)
    friendships.exists?(friend: other_user, status: 'accepted') || 
    inverse_friendships.exists?(user: other_user, status: 'accepted')
  end

  # Checks if there's a pending friend request sent to the other user
  def pending_friend_request?(other_user)
    friendships.exists?(friend: other_user, status: 'pending')
  end

  # Checks if a friend request has been received and is pending
  def friend_request_received?(other_user)
    inverse_friendships.exists?(user: other_user, status: 'pending')
  end

  # Checks if the current user is already friends with another user
  def friend_with?(other_user)
    friendships.exists?(friend: other_user, status: 'accepted') || 
    inverse_friendships.exists?(user: other_user, status: 'accepted')
  end
end


