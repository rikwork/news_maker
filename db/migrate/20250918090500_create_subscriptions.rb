class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: "inactive" # inactive, active, canceled
      t.string :provider # stripe, tg-payments, etc
      t.string :external_id
      t.datetime :current_period_end_at
      t.string :plan

      t.timestamps
    end

    add_index :subscriptions, [ :user_id, :status ]
  end
end
