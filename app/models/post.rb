class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :restaurants, dependent: :destroy

  validates :title, presence: true
  validate :at_least_one_restaurant

  private

  def at_least_one_restaurant
    errors.add(:error, '少なくとも1つのお店を選択してください') if restaurants.empty?
  end
end
