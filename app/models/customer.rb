class Customer < ApplicationRecord
  validates :name, :address, :zip_code, :card_expiration_date, :card_cvv, :billing_zip_code, presence: true
end
