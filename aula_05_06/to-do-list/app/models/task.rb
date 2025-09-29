class Task < ApplicationRecord
  validates :title, :description, :due_date, presence: true

  enum :status, { ongoing: 0, overdue: 1, completed: 2, cancelled: 3 }

  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :not_deleted, -> { where(deleted_at: nil) }
end
