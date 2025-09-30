# frozen_string_literal: true
require "net/http"
require "json"
require "uri"

class HotpepperClient
  ENDPOINT = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/".freeze

  def initialize(api_key: Rails.application.credentials.hotpepper_api_key, open_timeout: 3, read_timeout: 5)
    @api_key = api_key
    @open_timeout = open_timeout
    @read_timeout = read_timeout
  end

  def search(keyword: nil, address: nil, start: nil, count: nil)
    params = { key: @api_key, format: "json" }
    params[:keyword] = keyword if keyword.present?
    params[:address] = address if address.present?
    params[:start] = start if start.present?
    params[:count] = count if count.present?
    get_json(params)
  end

  def fetch_by_id(shop_id)
    get_json(key: @api_key, id: shop_id, format: "json")
  end

  private

  def get_json(params)
    uri = URI(ENDPOINT)
    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = @open_timeout
    http.read_timeout = @read_timeout

    res = http.request(Net::HTTP::Get.new(uri))
    raise "Hotpepper error #{res.code}" unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end
end
