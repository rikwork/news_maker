require "sidekiq"
require "sidekiq-cron"

redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")
redis_params = { url: redis_url, network_timeout: 5 }

Sidekiq.configure_server do |config|
  config.redis = redis_params
  schedule_file = Rails.root.join("config", "schedule.yml")
  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_params
end
