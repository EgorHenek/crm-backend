class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.references :user, foreign_key: true
      t.datetime :published_at
      t.string :slug, unique: true
      t.timestamps
    end
  end
end
