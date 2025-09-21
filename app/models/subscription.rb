class Subscription < ApplicationRecord
  belongs_to :user

  STATUSES = %w[inactive active canceled].freeze

  validates :status, inclusion: { in: STATUSES }
end
