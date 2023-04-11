class Vote < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  has_many :vote_restaurants, dependent: :destroy

  validates :restaurant_id, presence: true
  validates :user_id, uniqueness: { scope: :restaurant_id, message: "投票済みです" }
end
