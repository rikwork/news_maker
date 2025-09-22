class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :channels, dependent: :nullify

  before_create :ensure_api_token

  def active_subscription?
    subscriptions.where(status: "active").where("current_period_end_at IS NULL OR current_period_end_at > ?", Time.current).exists?
  end

  def rotate_api_token!
    update!(api_token: generate_unique_token)
  end

  private

  def ensure_api_token
    self.api_token ||= generate_unique_token
  end

  def generate_unique_token
    loop do
      token = SecureRandom.hex(32)
      break token unless self.class.exists?(api_token: token)
    end
  end
end
 