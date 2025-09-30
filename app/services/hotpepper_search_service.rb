# frozen_string_literal: true
class HotpepperSearchService
  def initialize(client: HotpepperClient.new)
    @client = client
  end

  # 画面用に shops 配列だけ返す
  def call(keyword: nil, address: nil, start: nil, count: nil)
    json = @client.search(keyword: keyword, address: address, start: start, count: count)
    json.dig("results", "shop") || []
  rescue => e
    Rails.logger.error("[HotpepperSearchService] #{e.class}: #{e.message}")
    []
  end
end
