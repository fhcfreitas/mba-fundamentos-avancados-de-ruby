class CreatePipelines < ActiveRecord::Migration[8.0]
  def change
    create_table :pipelines do |t|
      t.string :name, null: false
      t.text :description
      t.jsonb :configuration
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :pipelines, :name, unique: true
    add_index :pipelines, :status
  end
end
