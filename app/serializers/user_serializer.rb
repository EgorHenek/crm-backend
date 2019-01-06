class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :second_name, :last_name, :full_name, :email, :blocked, :last_sign_in_at, :otp_required_for_login
  attribute :role do |record|
    record.roles.map(&:name).first
  end
end
