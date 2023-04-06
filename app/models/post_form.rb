class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes
    
  attr_accessor :title, :selected_restaurants, :user

  validates :title, presence: true
  validate :at_least_one_restaurant

  def save
    return if invalid?

    ActiveRecord::Base.transaction do

      def save
        return false unless valid?
      
        post = user.posts.create(title: title)
      
        selected_restaurants.each do |restaurant|
          post.restaurants.create(
            name: restaurant[:name],
            image: restaurant[:image],
            url: restaurant[:url]
          )
        end
      
        true
      end
    end
  end

  private

  def at_least_one_restaurant
    if selected_restaurants.blank? || (selected_restaurants[:name].blank?)
      errors.add(:base, '少なくとも1つのレストランを選択してください。')
    end
  end
end