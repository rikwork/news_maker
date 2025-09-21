class AiGeneratorService
  def initialize(model: ENV.fetch("AI_MODEL", "gpt4free"))
    @model = model
  end

  def generate_post_russian(original_name:, original_text:, theme:)
    prompt = <<~TXT
      Сформируй краткую новость на русском языке по теме: #{theme}.
      Суммаризируй и перефразируй исходный материал, добавь нейтральный заголовок.
      Выход:
      ---
      TITLE: <заголовок>
      BODY: <текст 800-1200 символов>
    TXT
    # Заглушка интеграции с gpt4free или иным API
    title = "#{theme}: #{original_name}".truncate(120)
    body = original_text.to_s[0, 1000]
    { name: title, text: body, ai_model: @model }
  end
end
