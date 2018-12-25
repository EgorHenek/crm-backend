class News < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :user

  validates :title, :description, :user, presence: true
  validates :slug, uniqueness: true
end
