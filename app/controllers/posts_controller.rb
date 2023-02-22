class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def index
    @posts = Post.includes(:user)
  end
end
