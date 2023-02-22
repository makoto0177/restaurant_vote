class RestaurantsController < ApplicationController
  require 'net/http'
  require 'JSON'

  before_action :get_hotpepper_res, only: [:index]

  def new
    @restaurant = Restaurant.new
  end

  def index
    @store_infomations = @parsed_json['results']['shop']
  end

  def search; end

  private

  def get_hotpepper_res
    uri = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
    api_key = ENV['HOTPEPPER_API_KEY']
    url = uri << "?key=" << api_key << "&large_area=Z011" << "&format=json" 
   
    if @search = params[:address]
      url = url << "&keyword=" 
    end

    res = Net::HTTP.get(URI.parse(url + URI.encode_www_form_component(@search)))
    @parsed_json = JSON.parse(res)
  end
end
