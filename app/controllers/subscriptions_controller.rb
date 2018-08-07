class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    customer = customer_find_or_create
    return render json: {errors: {customer: customer.errors}} if customer.errors.any?

    subscription_data = ValidateSubscriptionDataService.new(subscription_params, customer).call
    return render json: {errors: {subscription_data: subscription_data.errors}} if subscription_data.errors.any?

    subscription = CreateSubscriptionService.new(subscription_data, customer, subscription_params[:card_number]).call
    return render json: {errors: subscription.body} if subscription.is_a?(HTTParty::Response) && subscription&.response&.code == '401'

    if subscription["success"] == true
      subscription_data.save
      render json: {"success" => "true", "token" => subscription["token"]}
    else
      render json: {errors: {subscription: TranslateSubscriptionErrorService.new(subscription["error_code"]).call}}
    end
  end

  private

  def customer_find_or_create
    if existing_customer?
      Customer.find(customer_params[:id])
    else
      CreateCustomerService.new(subscription_params).call
    end
  end

  def existing_customer?
    params.has_key?(:customer) && customer_params[:id] && Customer.exists?(id: customer_params[:id])
  end

  def subscription_params
    @subscription_params ||= params.require(:subscription).permit(:card_number, :name, :address, :zip_code, :card_number, :card_expiration_date, :card_cvv, :billing_zip_code, :subscription_plan_id)
  end

  def customer_params
    @customer_params ||= params.require(:customer).permit(:id)
  end
end
