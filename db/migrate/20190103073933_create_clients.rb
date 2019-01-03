class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :address
      t.string :email, unique: true
      t.string :phone, unique: true
      t.boolean :promotion, default: true
      t.boolean :first_contact, default: false

      t.timestamps
    end
  end
end
