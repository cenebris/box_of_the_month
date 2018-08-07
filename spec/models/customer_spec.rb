require 'rails_helper'

RSpec.describe Customer, type: :model do
describe 'associations' do

end

describe 'validations' do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:zip_code) }
  it { is_expected.to validate_presence_of(:card_expiration_date) }
  it { is_expected.to validate_presence_of(:card_cvv) }
  it { is_expected.to validate_presence_of(:billing_zip_code) }
end


end
