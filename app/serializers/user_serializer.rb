class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :second_name, :last_name, :full_name, :email, :blocked
end
