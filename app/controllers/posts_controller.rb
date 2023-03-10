class PostsController < ApplicationController
  require 'net/http'
  require 'JSON'

  skip_before_action :require_login, only: %i[index show]
  before_action :get_hotpepper_res, only: %i[new]

  def new
    @post = Post.new
    @post.restaurants.build     
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path
    else
      redirect_to search_restaurants_path
    end
  end

  def index
    @posts = Post.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @restaurants = @post.restaurants
    @restaurant_count = @restaurants.map { |restaurant| [restaurant.name, restaurant.votes.count] }.to_h
  end  

  def vote
    @post = Post.find(params[:id])
    @restaurants = Restaurant.where(post_id: @post.id)
  end

  private

  def post_params
    params.require(:post).permit(:title, restaurants_attributes: [:name])
  end

  def get_hotpepper_res
    uri = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
    api_key = ENV['HOTPEPPER_API_KEY']
    url = uri << "?key=" << api_key << "&format=json" 
   
    if @search_keyword = params[:keyword]
      url = url << "&keyword=" << URI.encode_www_form_component(@search_keyword)
    end

    if @search_address = params[:address]
      url = url << "&address=" << URI.encode_www_form_component(@search_address)
    end

    res = Net::HTTP.get(URI.parse(url))
    @parsed_json = JSON.parse(res)

    @store_infomations = @parsed_json['results']['shop']
    @store_names = []
    @store_infomations.each do |info|
      @store_names << info['name']
    end
  end
end
