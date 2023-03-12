class VotesController < ApplicationController
  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    @vote = Vote.create(user: current_user, restaurant: restaurant)
    @post = Post.find_by(id: restaurant.post_id)
    if @vote.save
      redirect_to post_path(@post), success: t('.success')
    else
      @post = Post.find(params[:id])
      @restaurants = Restaurant.where(post_id: @post.id)
      flash.now[:error] = t('.fail')
      render template: "posts/vote", status: :unprocessable_entity
    end
  end
end
