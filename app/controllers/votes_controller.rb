class VotesController < ApplicationController
  before_action :set_post, only: %i[create]

  def create
    @restaurant = Restaurant.find_by(id: params.dig(:vote, :restaurant))
    @vote = Vote.new(user: current_user, restaurant: @restaurant)

    if @vote.save
      redirect_to post_path(@post), success: t('.success')
    else
      @restaurants = Restaurant.where(post_id: @post.id)
      flash.now[:error] = t('.fail')
      render template: 'posts/vote', status: :unprocessable_entity
    end
  end

  private

  def set_post
    binding.pry
    @post = Post.find(params[:id])
  end
end
