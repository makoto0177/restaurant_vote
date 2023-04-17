module PostsHelper
  require 'net/http'
  require 'json'

  def get_hotpepper_res(keyword: nil, address: nil)
    uri = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
    api_key = Rails.application.credentials.hotpepper_api_key
    url = uri << "?key=" << api_key << "&format=json" 

    if keyword
      url = url << "&keyword=" << URI.encode_www_form_component(keyword)
    end

    if address
      url = url << "&address=" << URI.encode_www_form_component(address)
    end

    res = Net::HTTP.get(URI.parse(url))
    parsed_json = JSON.parse(res)

    store_informations = parsed_json['results']['shop'] || []
  end
end
