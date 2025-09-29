class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :status
      t.date :due_date
      t.date :deleted_at

      t.timestamps
    end
  end
end
