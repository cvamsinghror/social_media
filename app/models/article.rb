class Article < ApplicationRecord
    has_one_attached :avatar
    has_many :comments,  dependent: :destroy
    belongs_to :user
    acts_as_votable
end
