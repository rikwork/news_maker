class TelegramPublisherService
  def initialize(token: nil)
    @token = token || ENV['TELEGRAM_BOT_TOKEN']
  end

  def publish(post:, channel:)
    raise ArgumentError, 'no bot token' if @token.blank?
    raise ArgumentError, 'no chat id' if channel.telegram_chat_id.blank?

    bot = Telegram::Bot::Client.new(@token)
    caption = "#{post.name}\n\n#{truncate(post.text, 900)}\n\nИсточник: #{post.original_url}"

    if post.photo.attached?
      io = StringIO.new(post.photo.download)
      bot.api.send_photo(chat_id: channel.telegram_chat_id, photo: Faraday::UploadIO.new(io, 'image/jpeg', 'image.jpg'), caption: caption)
    else
      bot.api.send_message(chat_id: channel.telegram_chat_id, text: caption)
    end
  end

  private

  def truncate(text, max)
    text.to_s.length > max ? text.to_s[0, max] + '…' : text.to_s
  end
end 