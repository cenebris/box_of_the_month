class ValidateSubscriptionDataService
  def initialize(params, customer)
    @subscription_plan_id = params[:subscription_plan_id]
    @customer = customer
  end

  def call
    subscription = Subscription.new(customer_id: @customer.id, subscription_plan_id: @subscription_plan_id)
  end
end
