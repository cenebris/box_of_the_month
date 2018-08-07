require 'rails_helper'

RSpec.describe Subscription, type: :model do
describe 'associations' do
  it { is_expected.to belong_to(:subscription_plan) }
  it { is_expected.to belong_to(:customer) }
end

describe 'validations' do
end


end
