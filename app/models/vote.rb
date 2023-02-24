class Vote < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  has_many :vote_restaurants, dependent: :destroy

  validates :user_id, uniqueness: { scope: :restaurant_id }
end
