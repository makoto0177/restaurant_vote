class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :restaurants, dependent: :destroy
  has_many :votes, through: :restaurants
  accepts_nested_attributes_for :restaurants, allow_destroy: true,  reject_if: proc { |attributes| attributes['name'].blank? }


  validates :title, presence: true
  validate :at_least_one_restaurant

  def voted_by?(user)
    votes.exists?(user_id: user.id) 
  end

  private

  def at_least_one_restaurant
    errors.add(:base, '少なくとも1つのお店を選択してください') if restaurants.empty?
  end
end
