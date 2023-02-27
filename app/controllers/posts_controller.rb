class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def index
    @posts = Post.includes(:user)
  end

  def show
    @post = Post.find(params[:id])
    @restaurants = Restaurant.where(post_id: @post.id)
    @chart = {'飲食店aaa'=>2, '飲食店bbb'=>1}
  end  

  def vote
    @post = Post.find(params[:id])
    @restaurants = Restaurant.where(post_id: @post.id)
  end

  private

  def post_params
    params.require(:post).permit(:title)
  end
end
