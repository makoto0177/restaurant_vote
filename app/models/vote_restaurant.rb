class VoteRestaurant < ApplicationRecord
  belongs_to :restaurant
  belongs_to :vote
end
