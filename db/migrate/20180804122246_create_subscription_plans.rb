class CreateSubscriptionPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :subscription_plans do |t|
      t.text :name
      t.float :price

      t.timestamps
    end
  end
end
