class Channel < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "name", "token", "updated_at" ]
  end
end
