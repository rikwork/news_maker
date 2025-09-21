class Post < ApplicationRecord
  belongs_to :channel
  belongs_to :source, optional: true

  has_one_attached :photo

  STATUSES = {
    draft: "draft",
    ready: "ready",
    published: "published",
    failed: "failed"
  }.freeze

  validates :status, inclusion: { in: STATUSES.values }

  scope :drafts, -> { where(status: STATUSES[:draft]) }
  scope :ready_for_publish, -> { where(status: STATUSES[:ready]) }
end
