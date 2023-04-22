class VotesController < ApplicationController
  before_action :set_post, only: %i[create]

  def create
    @restaurant = Restaurant.find_by(id: params.dig(:vote, :restaurant_id))
    @vote = Vote.new(user: current_user, restaurant: @restaurant)

    if @post.voted_by?(current_user) 
      redirect_to post_path(@post), error: t('.already_voted')
    else
      if @vote.save
        redirect_to post_path(@post), success: t('.success')
      else
        @restaurants = Restaurant.where(post_id: @post.id)
        flash.now[:error] = t('.fail')
        render template: 'posts/vote', status: :unprocessable_entity
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
