# frozen_string_literal: true

class Task < ApplicationRecord
  acts_as_paranoid
  resourcify
  audited

  has_many :tasks_users
  has_many :users, through: :tasks_users

  validates :title, presence: true
  validates :description, presence: true
  validates :start_time, presence: true
  validates :color, presence: true

  def before_validation
    self.color = 'white' if color.blank?
  end

  def creator
    tasks_users.find_by(role: 'creator').user
  end

  def performer
    performer = tasks_users.find_by(role: 'performer')
    !performer.nil? ? performer.user : creator
  end

  def subcontactors
    tasks_users.where(role: 'subcontactor').map(&:user)
  end
end
