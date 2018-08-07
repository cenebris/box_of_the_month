require 'rails_helper'

RSpec.describe SubscriptionPlan, type: :model do
describe 'associations' do

end

describe 'validations' do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:price) }
end


end
