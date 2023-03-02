class PostsController < ApplicationController
  require 'net/http'
  require 'JSON'

  before_action :get_hotpepper_res, only: [:new]

  def new
    @post = Post.new
    @post.restaurants.build
    @store_infomations = @parsed_json['results']['shop']
    @store_names = []
    @store_infomations.each do |info|
      @store_names << info['name']
    end
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
    params.require(:post).permit(:title, restaurants_attributes: ["0": [name:[]]])
  end

  def get_hotpepper_res
    uri = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
    api_key = ENV['HOTPEPPER_API_KEY']
    url = uri << "?key=" << api_key << "&large_area=Z011" << "&format=json" 
   
    if @search = params[:search]
      url = url << "&keyword=" 
    end

    res = Net::HTTP.get(URI.parse(url + URI.encode_www_form_component(@search)))
    @parsed_json = JSON.parse(res)
  end
end
