# frozen_string_literal: true

class TasksUser < ApplicationRecord
  table_name = 'tasks_users'

  belongs_to :task, autosave: false
  belongs_to :user, autosave: false
  ROLES = %w[creator subcontactor performer].freeze

  validates :task, presence: true, uniqueness: { scope: :user }
  validates :user, presence: true, uniqueness: { scope: :task }
  validates :role, presence: true, inclusion: { in: ROLES }
  validate :user_role

  def user_role
    errors.add(:user, 'Этот пользователь не имеет прав для работы с тасками') if user.has_role? :client
  end
end
