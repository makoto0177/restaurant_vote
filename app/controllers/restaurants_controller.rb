class RestaurantsController < ApplicationController
  require 'net/http'
  require 'JSON'

  def new
    @restaurant = Restaurant.new
  end

  def search; end
end
