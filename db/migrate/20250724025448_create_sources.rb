class CreateSources < ActiveRecord::Migration[7.2]
  def change
    create_table :sources do |t|
      t.string :url
      t.boolean :enabled

      t.references :channel, null: false, foreign_key: true
      t.timestamps
    end
  end
end
