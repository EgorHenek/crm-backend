class ClientSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :address, :phone, :promotion, :email, :first_contact, :created_at, :updated_at
end
