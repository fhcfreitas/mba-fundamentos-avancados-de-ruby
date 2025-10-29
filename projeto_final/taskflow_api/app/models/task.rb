class Task < ApplicationRecord
  belongs_to :pipeline

  validates :name, presence: true, uniqueness: { scope: :pipeline_id }
  validates :task_type, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  default_scope { order(position: :asc) }

  def dependencies
    return [] if depends_on.blank?
    pipeline.tasks.where(name: depends_on)
  end
end
