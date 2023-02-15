class Vote < ApplicationRecord
  belogns_to :restaurant
  belogns_to :user
  has_many :vote_restaurants, dependent: :destroy
end
