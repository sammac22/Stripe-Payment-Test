#1
require 'sinatra'
require 'stripe'
require 'json'

#2 Grabs api key from config file
Stripe.api_key = File.read('./.apikey')

#3
get '/' do
  status 200
  return "BadBoyButton back end has been set up correctly"
end

#4
post '/charge' do
  #5
  payload = params
  if request.content_type.include? 'application/json' and params.empty?
    payload = indifferent_params(JSON.parse(request.body.read))
  end

  begin
    #6
    charge = Stripe::Charge.create(
      :amount => payload[:amount],
      :currency => payload[:currency],
      :source => payload[:token],
      :description => payload[:description]
    )
    #7
    rescue Stripe::StripeError => e
    status 402
    return "Error creating charge: #{e.message}"
  end
  #8
  status 200
  return "Charge successfully created"

end

post '/customers' do

	payload = params
	if request.content_type.include? 'application/json' and params.empty?
    	payload = indifferent_params(JSON.parse(request.body.read))
  	end

  	begin

  		customer = Stripe::Customer.create(
		  :description => payload[:description],
		  :source => payload[:token] # obtained with Stripe.js
		)

		rescue Stripe::StripeError => e
    	status 402
    	return "Error creating charge: #{e.message}"
  	end

  	status 200
  	return "Customer successfully created"

end




