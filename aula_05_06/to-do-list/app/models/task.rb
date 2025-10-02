class Task < ApplicationRecord
  include SoftDeletable

  after_initialize :set_default_status, if: :new_record?
  validates :title, :description, presence: true

  enum :status, { ongoing: 0, overdue: 1, completed: 2, cancelled: 3 }

  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :not_deleted, -> { where(deleted_at: nil) }

  def self.ransackable_attributes(_auth_object = nil)
    [ "created_at", "deleted_at", "description", "due_date", "id", "status", "title", "updated_at" ]
  end

  private

  def set_default_status
    self.status ||= :ongoing
  end
end
