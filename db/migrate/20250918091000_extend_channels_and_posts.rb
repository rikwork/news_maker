class ExtendChannelsAndPosts < ActiveRecord::Migration[7.2]
  def change
    change_table :channels do |t|
      t.string :theme
      t.string :telegram_chat_id
      t.references :user, foreign_key: true
    end

    change_table :posts do |t|
      t.string :status, null: false, default: "draft" # draft, ready, published, failed
      t.string :original_url
      t.string :language, default: "ru"
      t.string :ai_model
      t.datetime :publish_at
      t.datetime :published_at
    end

    add_index :posts, :status
  end
end
