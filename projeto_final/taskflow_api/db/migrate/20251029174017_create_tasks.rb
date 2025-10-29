class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.string :name, null: false
      t.string :task_type
      t.jsonb :params, default: {}
      t.integer :position
      t.string :depends_on, array: true, default: []

      t.timestamps
    end

    add_index :tasks, [:pipeline_id, :name], unique: true
    add_index :tasks, :position
  end
end
