module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :not_deleted, -> { where(deleted_at: nil) }
    scope :deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
  end

  def soft_delete
    update(deleted_at: Time.current, status: :cancelled)
  end

  def deleted?
    deleted_at.present?
  end
end
