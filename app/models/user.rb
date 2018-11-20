# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :two_factor_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist,
                               otp_secret_encryption_key: Rails.application.credentials[Rails.env.to_sym][:otp_secret]
  validates :first_name, presence: true
  validates :last_name, presence: true
end
