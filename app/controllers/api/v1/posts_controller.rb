class Api::V1::PostsController < Api::V1::BaseController
  def index
    posts = Post.joins(:channel).where(channels: { user_id: current_user.id }).order(created_at: :desc)
    render json: posts
  end

  def create
    channel = current_user.channels.find(params[:channel_id])
    post = channel.posts.create!(post_params.merge(status: Post::STATUSES[:draft]))
    render json: post
  end

  def publish
    post = Post.joins(:channel).where(channels: { user_id: current_user.id }).find(params[:id])
    PublishPostJob.perform_later(post.id)
    render json: { ok: true }
  end

  private

  def post_params
    params.require(:post).permit(:name, :text, :original_url, :original_name, :original_text)
  end
end
