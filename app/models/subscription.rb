class Subscription < ApplicationRecord
  belongs_to :subscription_plan
  belongs_to :customer 
end
