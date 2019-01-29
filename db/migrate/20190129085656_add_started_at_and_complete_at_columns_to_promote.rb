class AddStartedAtAndCompleteAtColumnsToPromote < ActiveRecord::Migration[5.2]
  def change
    add_column :promotes, :started_at, :datetime
    add_column :promotes, :complete_at, :datetime
  end
end
