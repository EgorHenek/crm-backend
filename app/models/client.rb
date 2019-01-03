# frozen_string_literal: true

class Client < ApplicationRecord
  validates :name, presence: true
  validate :phone_or_email_presence
  validates :phone, length: { is: 10 }, numericality: { only_integer: true }, allow_blank: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Email имеет неверный формат' },
                    allow_blank: true,
                    uniqueness: true


  def phone_or_email_presence
    errors.add(:email, 'Телефон или email обязательны для заполнения') unless phone.present? && email.present?
  end

  before_validation do
    phone.gsub!(/\D/, '') if phone.present?
  end
end
