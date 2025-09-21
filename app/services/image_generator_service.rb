class ImageGeneratorService
  def initialize(provider: ENV.fetch("IMG_PROVIDER", "placeholder"))
    @provider = provider
  end

  def generate_image(theme:, fallback_url: nil)
    # Заглушка: возвращаем URL плейсхолдера; в будущем - интеграция с провайдером
    fallback_url || "https://picsum.photos/seed/#{CGI.escape(theme.to_s)}/1200/630"
  end
end
