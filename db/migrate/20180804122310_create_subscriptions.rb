class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :customer
      t.references :subscription_plan, foreign_key: true

      t.timestamps
    end
  end
end
