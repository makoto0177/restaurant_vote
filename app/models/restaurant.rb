class Restaurant < ApplicationRecord
  belongs_to :post
  has_many :votes, dependent: :destroy
  has_many :vote_restaurants, dependent: :destroy

  validates :name, presence: true
end
