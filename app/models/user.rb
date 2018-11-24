# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :two_factor_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist,
                               otp_secret_encryption_key: Rails.application.credentials[Rails.env.to_sym][:otp_secret]
  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :tasks

  def full_name
    "#{first_name} #{last_name} #{second_name}"
  end

  def assign_default_role
    self.add_role(:client) if self.roles.blank?
  end
end
