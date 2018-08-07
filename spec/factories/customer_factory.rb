FactoryBot.define do
  factory :customer do
    name 'Customer Name'
    address 'Customer Address'
    zip_code '12345'
    card_expiration_date { Date.today + 1.year }
    card_cvv '456'
    billing_zip_code '23456'
  end
end
