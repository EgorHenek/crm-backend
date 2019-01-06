class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :start_time, null: false
      t.boolean :started, default: false
      t.datetime :end_time
      t.boolean :ended, default: false
      t.string :color
      t.datetime :notify
      t.timestamps
    end
  end
end
