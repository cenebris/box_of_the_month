class CreateCustomerService
  def initialize(params)
    @name = params[:name]
    @address = params[:address]
    @zip_code = params[:zip_code]
    @card_expiration_date = params[:card_expiration_date]
    @card_cvv = params[:card_cvv]
    @billing_zip_code = params[:billing_zip_code]
  end

  def call
    customer = Customer.create(
      name: @name,
      address: @address,
      zip_code: @zip_code,
      card_expiration_date: @card_expiration_date,
      card_cvv: @card_cvv,
      billing_zip_code: @billing_zip_code
    )
  end
end
