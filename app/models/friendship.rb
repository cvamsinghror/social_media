class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum status: { pending: 0, accepted: 1, rejected: 2 }
end