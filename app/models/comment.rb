class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true
  validates :body, length: { maximum: 100 }

  def own?(user)
    self.user == user
  end
end
