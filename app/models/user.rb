class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true 
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }


  def own?(object)
    id == object.user_id
  end
end
