class PublishPostJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)
    PostPublisher.new.publish!(post)
  rescue PostPublisher::Forbidden => e
    Rails.logger.warn("PublishPostJob forbidden: #{e.message}")
  rescue => e
    Rails.logger.error("PublishPostJob error: #{e.class} #{e.message}")
    post.update(status: Post::STATUSES[:failed]) if post
  end
end
