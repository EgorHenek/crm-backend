class CreatePromotes < ActiveRecord::Migration[5.2]
  def change
    create_table :promotes do |t|
      t.string :title, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
