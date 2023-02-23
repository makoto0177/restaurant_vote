class Vote < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  has_many :vote_restaurants, dependent: :destroy
end
