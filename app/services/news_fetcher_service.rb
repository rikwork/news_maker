require "rss"

class NewsFetcherService
  def initialize(channel)
    @channel = channel
  end

  def fetch_latest(limit: 10)
    items = []
    @channel.sources.where(enabled: true).limit(20).find_each do |source|
      begin
        fetched = fetch_from_source(source)
        items.concat(fetched)
      rescue => e
        Rails.logger.warn("NewsFetcherService error: #{e.class} #{e.message}")
      end
    end
    items.first(limit)
  end

  private

  def fetch_from_source(source)
    url = source.url
    body = HTTParty.get(url, timeout: 10).body.to_s
    parse_rss(body, url, source) || [
      {
        source_id: source.id,
        original_url: url,
        original_name: "Материал по теме #{channel_theme}",
        original_text: body[0, 2000],
        original_image_url: nil
      }
    ]
  rescue => e
    Rails.logger.debug("fetch_from_source fallback for #{url}: #{e.message}")
    [ { source_id: source.id, original_url: url, original_name: url, original_text: "", original_image_url: nil } ]
  end

  def parse_rss(body, base_url, source)
    rss = RSS::Parser.parse(body, false)
    return nil unless rss&.items
    rss.items.first(5).map do |i|
      {
        source_id: source.id,
        original_url: i.respond_to?(:link) ? i.link.to_s.presence || base_url : base_url,
        original_name: i.respond_to?(:title) ? i.title.to_s : "\u0411\u0435\u0437 \u043D\u0430\u0437\u0432\u0430\u043D\u0438\u044F",
        original_text: i.respond_to?(:description) ? ActionView::Base.full_sanitizer.sanitize(i.description.to_s)[0, 2000] : "",
        original_image_url: extract_image_from_rss_item(i)
      }
    end
  rescue
    nil
  end

  def extract_image_from_rss_item(item)
    if item.respond_to?(:enclosure) && item.enclosure&.type&.start_with?("image/")
      return item.enclosure.url.to_s
    end
    nil
  end

  def channel_theme
    @channel.theme.presence || @channel.name
  end
end
