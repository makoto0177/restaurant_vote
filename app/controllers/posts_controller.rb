class PostsController < ApplicationController
  require 'net/http'
  require 'json'

  skip_before_action :require_login, only: %i[index show]
  before_action :get_hotpepper_res, only: %i[new]

  def new
    @post_form = PostForm.new
  end

  def create
    @post_form = PostForm.new(post_form_params)
  
    if @post_form.save
      redirect_to posts_path, success: t('.success')
    else
      get_hotpepper_res
      flash.now[:error] = t('.fail')
      render :new
    end
  end

  def index
    @posts = Post.all.includes(:user).order(created_at: :desc).page(params[:page])
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
  end  

  def vote
    @vote = Vote.new
    @post = Post.find(params[:id])
    @restaurants = Restaurant.where(post_id: @post.id)
  end

  private

  def post_form_params
    params.require(:post_form).permit(:title, restaurants: [:name, :image, :url])
  end
  
  def get_hotpepper_res
    uri = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
    api_key = Rails.application.credentials.hotpepper_api_key
    url = uri << "?key=" << api_key << "&format=json" 
   
    if @search_keyword = params[:keyword]
      url = url << "&keyword=" << URI.encode_www_form_component(@search_keyword)
    end

    if @search_address = params[:address]
      url = url << "&address=" << URI.encode_www_form_component(@search_address)
    end

    res = Net::HTTP.get(URI.parse(url))
    @parsed_json = JSON.parse(res)

    @store_informations = @parsed_json['results']['shop'] || []
  end
end
