class Comment < ApplicationRecord
  belogns_to :user
  belogns_to :post

  validates :body, presence: true
end
