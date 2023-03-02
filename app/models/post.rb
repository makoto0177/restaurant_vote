class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :restaurants, dependent: :destroy, inverse_of: :post
  accepts_nested_attributes_for :restaurants

  validates :title, presence: true
end
