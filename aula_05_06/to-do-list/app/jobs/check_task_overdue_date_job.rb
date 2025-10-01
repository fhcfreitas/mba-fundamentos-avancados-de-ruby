class CheckTaskOverdueDateJob < ApplicationJob
  queue_as :default

  def perform
    Task.where("due_date < ? AND status = ?", Time.current, Task.statuses[:ongoing]).find_each do |task|
      task.update(status: :overdue)
    end
  end
end
