require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe '#create' do
    it 'returns customer errors if customer.errors.any?' do
      test_customer = create(:customer)
      test_customer.errors.add(:name, 'Not Valid')
      allow(controller).to receive(:customer_find_or_create).and_return(test_customer)
      post :create
        expect(JSON.parse(response.parsed_body)).to eq({"errors"=>{"customer"=>{"name"=>["Not Valid"]}}})
    end

    it 'returns subscription errors if subscription.errors.any?' do
      test_customer = create(:customer)
      test_subscription = create(:subscription, customer: test_customer)
      test_subscription.errors.add(:customer, "Can't be blank")
      allow(controller).to receive(:customer_find_or_create).and_return(test_customer)
      allow(ValidateSubscriptionDataService).to receive_message_chain(:new, :call).and_return(test_subscription)
      post :create, params: {"subscription": {"subscription_plan_id": "3", "name": "Customer Name", "address": "Customer Address", "zip_code": "12345", "card_expiration_date": "2020-05-05", "card_cvv": "123", "billing_zip_code": "12345", "card_number": "4242424242424242" }}
      expect(JSON.parse(response.parsed_body)).to eq({"errors"=>{"subscription_data"=>{"customer"=>["Can't be blank"]}}})
    end

    it 'makes unsuccessful external api call to subscription service' do
      test_customer = create(:customer)
      test_subscription = create(:subscription, customer: test_customer)
      allow(controller).to receive(:customer_find_or_create).and_return(test_customer)
      allow(ValidateSubscriptionDataService).to receive_message_chain(:new, :call).and_return(test_subscription)
      post :create, params: {"subscription": {"subscription_plan_id": "3", "name": "Customer Name", "address": "Customer Address", "zip_code": "12345", "card_expiration_date": "2020-05-05", "card_cvv": "123", "billing_zip_code": "12345", "card_number": "4242424242424242" }}
      expect(JSON.parse(response.parsed_body)).to eq({"errors"=>{"subscription"=>"CVV failure"}})
    end

    it 'makes successful external api call to subscription service' do
      test_customer = create(:customer)
      test_subscription = create(:subscription, customer: test_customer)
      allow(controller).to receive(:customer_find_or_create).and_return(test_customer)
      allow(ValidateSubscriptionDataService).to receive_message_chain(:new, :call).and_return(test_subscription)
      allow(CreateSubscriptionService).to receive_message_chain(:new, :call).and_return({'success' => true, 'token' => 'token'})
      post :create, params: {"subscription": {"subscription_plan_id": "3", "name": "Customer Name", "address": "Customer Address", "zip_code": "12345", "card_expiration_date": "2020-05-05", "card_cvv": "123", "billing_zip_code": "12345", "card_number": "4242424242424242" }}
      expect(JSON.parse(response.parsed_body)).to eq({"success" => "true", "token" => "token"})
    end
  end

  describe '#existing_customer?' do
    it 'returns false if no params[:customer]' do
      expect(controller.send(:existing_customer?)).to eq(false)
    end

    it 'returns false if params[:customer] exist but no Customer exists' do
      controller.params = { customer: {id: 1}}
      expect(controller.send(:existing_customer?)).to eq(false)
    end

    it 'returns true if params[:customer] exist and Customer exists' do
      customer = create(:customer)
      controller.params = { customer: {id: customer.id} }
      expect(controller.send(:existing_customer?)).to eq(true)
    end
  end

  describe '#customer_find_or_create' do
    it 'finds customer if customer exists' do
      customer = create(:customer)
      controller.params = { customer: {id: customer.id}}
      allow(controller).to receive(:existing_customer?).and_return(true)
      expect(controller.send(:customer_find_or_create)).to eq(Customer.find(customer.id))
    end

    it 'creates new customer when no existing customer exists' do
      controller.params = {"subscription": {"subscription_plan_id": "3", "name": "Customer Name", "address": "Customer Address", "zip_code": "12345", "card_expiration_date": "2020-05-05", "card_cvv": "123", "billing_zip_code": "12345", "card_number": "4242424242424242" }}
      allow(controller).to receive(:existing_customer?).and_return(false)
      allow(CreateCustomerService).to receive_message_chain(:new, :call)
      expect(controller.send(:customer_find_or_create)).to eq(CreateCustomerService.new(controller.params).call)
    end

  end
end
