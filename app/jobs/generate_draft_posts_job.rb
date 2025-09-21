class GenerateDraftPostsJob < ApplicationJob
  queue_as :default

  def perform
    Channel.find_each do |channel|
      fetch_and_build_for_channel(channel)
    end
  end

  private

  def fetch_and_build_for_channel(channel)
    fetched = NewsFetcherService.new(channel).fetch_latest(limit: 5)
    ai = AiGeneratorService.new
    img = ImageGeneratorService.new

    fetched.each do |item|
      next if Post.exists?(original_url: item[:original_url], channel_id: channel.id)

      ai_result = ai.generate_post_russian(
        original_name: item[:original_name],
        original_text: item[:original_text],
        theme: channel.theme || channel.name
      )

      post = Post.new(
        channel_id: channel.id,
        source_id: item[:source_id],
        original_name: item[:original_name],
        original_text: item[:original_text],
        original_url: item[:original_url],
        original_image_url: item[:original_image_url],
        name: ai_result[:name],
        text: ai_result[:text],
        ai_model: ai_result[:ai_model],
        status: Post::STATUSES[:draft]
      )

      image_url = img.generate_image(theme: channel.theme, fallback_url: item[:original_image_url])
      attach_remote_image(post, image_url) if image_url.present?

      post.save!
    rescue => e
      Rails.logger.error("GenerateDraftPostsJob error for channel=#{channel.id}: #{e.class} #{e.message}")
    end
  end

  def attach_remote_image(post, url)
    require "open-uri"
    file = URI.parse(url).open
    post.photo.attach(io: file, filename: File.basename(URI.parse(url).path.presence || "image.jpg"))
  rescue => e
    Rails.logger.warn("attach_remote_image failed: #{e.class} #{e.message}")
  end
end
