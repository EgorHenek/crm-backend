# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :two_factor_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist,
                               otp_secret_encryption_key: Rails.application.credentials[Rails.env.to_sym][:otp_secret]
  validates :first_name, presence: true
  validates :second_name, presence: true
  has_many :tasks

  def full_name
    "#{first_name} #{second_name} #{last_name}"
  end

  def active_for_authentication?
    super && !blocked
  end
end
