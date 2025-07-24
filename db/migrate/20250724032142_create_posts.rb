class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :original_name
      t.string :original_text
      t.string :original_image_url
      t.string :name
      t.string :text

      t.references :channel, null: false, foreign_key: true
      t.references :source

      t.timestamps
    end
  end
end
