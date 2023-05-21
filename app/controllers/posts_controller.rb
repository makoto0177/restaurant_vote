class PostsController < ApplicationController
  include PostsHelper

  skip_before_action :require_login, only: %i[index show]

  def new
    @post = Post.new
    @post.restaurants.build
    @store_informations = get_hotpepper_res(keyword: params[:keyword], address: params[:address])
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = '投稿が作成されました。'
      redirect_to posts_path
    else
      @store_informations = get_hotpepper_res(keyword: params[:keyword], address: params[:address])
      render :new
    end
  end
  

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: t('.success'), status: :see_other
  end

  def show
    @post = Post.find(params[:id])
    @restaurants = @post.restaurants
    @restaurant_count = @restaurants.map { |restaurant| [restaurant.name, restaurant.votes.count] }.to_h
    max_votes = @restaurants.max_by { |restaurant| restaurant.votes.count }.votes.count
    @max_voted_restaurants = @restaurants.select { |restaurant| restaurant.votes.count == max_votes }
    @max_value = @restaurant_count.values.max
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :asc)
  end  

  def vote
    @vote = Vote.new
    @post = Post.find(params[:id])
    @restaurants = Restaurant.where(post_id: @post.id)
  end

  private

  def post_params
    params.require(:post).permit(:title, restaurants_attributes: [:name, :image, :url])
  end
end