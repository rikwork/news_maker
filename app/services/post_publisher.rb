class PostPublisher
  class Forbidden < StandardError; end

  def initialize(telegram: TelegramPublisherService.new)
    @telegram = telegram
  end

  def publish!(post)
    channel = post.channel
    owner = channel.user
    raise Forbidden, "no owner" unless owner
    raise Forbidden, "subscription required" unless owner.active_subscription?

    @telegram.publish(post: post, channel: channel)
    post.update!(status: Post::STATUSES[:published], published_at: Time.current)
  end
end
