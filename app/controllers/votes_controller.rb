class VotesController < ApplicationController
  def create
    @restaurant = Restaurant.find(params[:vote][:restaurant_id])
    @vote = Vote.create(user: current_user, restaurant: @restaurant)
    if @vote.save
      @post = Post.find(@restaurant.post_id)
      redirect_to post_path(@post), success: t('.success')
    else
      @post = Post.find(@restaurant.post_id)
      @restaurants = Restaurant.where(post_id: @post.id)
      flash.now[:error] = t('.fail')
      render template: 'posts/vote', status: :unprocessable_entity
    end
  end
end
