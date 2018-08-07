class SubscriptionPlan < ApplicationRecord
  validates :name, :price, presence: true
end
