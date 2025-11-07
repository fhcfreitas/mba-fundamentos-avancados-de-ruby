class Pipeline < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  enum :status, { active: 0, draft: 1, archived: 2 }

  scope :active, -> { where(status: :active) }

  def self.build(&block)
    builder = Dsl::PipelineBuilder.new
    builder.instance_eval(&block)
    builder.create_pipeline
  end
end
