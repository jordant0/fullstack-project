# frozen_string_literal: true

require 'GiphyClient'

# Wrapper client for image connection and searching
class ImageClient
  attr_reader :api_instance, :api_key

  DEFAULT_OPTIONS = {
    limit: 25,
    offset: 0,
    rating: 'g',
    lang: 'en',
    fmt: 'json'
  }.freeze

  def initialize
    @api_instance = GiphyClient::DefaultApi.new
    @api_key = ENV.fetch('GIPHY_API_KEY', '')
  end

  def search(query = nil, options = {})
    results = api_instance.gifs_search_get(
      api_key,
      query.present? ? "cat #{query}" : 'cat',
      DEFAULT_OPTIONS.merge(options)
    )

    parse_results(results)
  rescue GiphyClient::ApiError => e
    Rails.logger.error { "Error fetching image: #{e}" }
  end

  private

  def parse_results(results)
    results.data.map do |image|
      {
        source_id: image.id,
        origin_url: image.url,
        url: image.images.fixed_height&.url || image.images.original&.url
      }
    end
  end
end
