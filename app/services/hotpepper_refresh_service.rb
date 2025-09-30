# frozen_string_literal: true
class HotpepperRefreshService
  TTL = 23.hours

  def initialize(client: HotpepperClient.new)
    @client = client
  end

  def refresh_if_stale!(restaurants)
    targets = restaurants.select { |r|
      r.external_shop_id.present? && (r.fetched_at.nil? || r.fetched_at < TTL.ago)
    }
    return if targets.empty?

    targets.each do |r|
      raise "missing external_shop_id" if r.external_shop_id.blank?

      payload = @client.fetch_by_id(r.external_shop_id)
      shop = (payload.dig("results", "shop") || []).first
      raise "empty shop for id=#{r.external_shop_id}" unless shop

      r.update!(
        name:       shop["name"],
        image:      shop.dig("photo","mobile","l"),
        url:        shop.dig("urls","pc"),
        fetched_at: Time.current
      )
    end
  end
end
