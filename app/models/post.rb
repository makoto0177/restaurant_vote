class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :restaurants, dependent: :destroy

  validates :title, presence: true
end
