class CreateSubscriptionService
  include HTTParty
  base_uri 'https://www.fakepay.io/purchase'

  def initialize(subscription, customer, card_number)
    @amount = subscription.subscription_plan.price.to_s.remove('.')
    @card_number = card_number
    @cvv = customer.card_cvv
    @expiration_month = customer.card_expiration_date.strftime("%m")
    @expiration_year = customer.card_expiration_date.strftime("%Y")
    @zip_code = customer.zip_code
  end

  def call
    query = {
      "amount" => @amount,
      "card_number" => @card_number,
      "cvv" => @cvv,
      "expiration_month" => @expiration_month,
      "expiration_year" => @expiration_year,
      "zip_code" => @zip_code
    }

    headers = {
      "Authorization" => "Token token=\"#{Rails.application.secrets.fakepay_api_key}\"",
      "Accept" => "application/json"
    }

    HTTParty.post("https://www.fakepay.io/purchase", query: query, headers: headers)
  end
end
