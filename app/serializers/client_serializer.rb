class ClientSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :address, :phone, :promotion, :email
end
