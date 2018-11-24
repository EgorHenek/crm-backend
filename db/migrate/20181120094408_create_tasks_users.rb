# frozen_string_literal: true

class CreateTasksUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks_users do |t|
      t.belongs_to :task, foreign_key: true, index: true
      t.belongs_to :user, index: true, foreign_key: true
      t.string :role, null: false

      t.index %i[user_id task_id], unique: true
    end
  end
end
