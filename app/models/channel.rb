class Channel < ApplicationRecord
  belongs_to :user, optional: true
  has_many :posts, dependent: :destroy
  has_many :sources, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "name", "token", "updated_at", "theme", "telegram_chat_id", "user_id" ]
  end
end
