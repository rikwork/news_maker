class Api::V1::ChannelsController < Api::V1::BaseController
  def index
    render json: current_user.channels
  end

  def create
    channel = current_user.channels.create!(channel_params)
    render json: channel
  end

  def update
    channel = current_user.channels.find(params[:id])
    channel.update!(channel_params)
    render json: channel
  end

  private

  def channel_params
    params.require(:channel).permit(:name, :theme, :telegram_chat_id, :token)
  end
end
