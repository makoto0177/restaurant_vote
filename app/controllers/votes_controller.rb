class VotesController < ApplicationController
  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    @vote = Vote.create(user: current_user, restaurant: restaurant)
    @post = Post.find_by(id: restaurant.post_id)
    if @vote.save
      redirect_to root_path
    else
      redirect_to vote_post_path(@post)
    end
  end


end
