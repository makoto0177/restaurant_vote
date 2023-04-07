class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :title, :restaurants, :user

  validates :title, presence: true
  # validate :at_least_one_restaurant

  def initialize(attributes = {})
    super(attributes)
    @restaurants = attributes[:restaurants]&.values || []
  end
  
  def save
    return if invalid?
  
    ActiveRecord::Base.transaction do
      post = Post.new(title: title)
  
      if restaurants.present?
        restaurants.each do |restaurant|
          post.restaurants.create(
            name: restaurant[:name],
            image: restaurant[:image],
            url: restaurant[:url]
          )
        end
      end
  
      true
    end
  end
  

  private

  # def at_least_one_restaurant
  #   if selected_restaurants.blank? || (selected_restaurants[:name].blank?)
  #     errors.add(:base, '少なくとも1つのレストランを選択してください。')
  #   end
  # end
end