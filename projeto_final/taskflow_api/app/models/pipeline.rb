
class Pipeline < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  enum :status, { draft: 0, active: 1, archived: 2 }

  scope :active, -> { where(status: :active) }
end
