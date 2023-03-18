class RestaurantsController < ApplicationController
  require 'net/http'
  require 'json'

  def new
    @restaurant = Restaurant.new
  end

  def search; end
end
