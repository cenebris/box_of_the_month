class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.text :name
      t.text :address
      t.text :zip_code
      t.date :card_expiration_date
      t.integer :card_cvv
      t.text :billing_zip_code

      t.timestamps
    end
  end
end
