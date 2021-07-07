require 'httparty'
require 'oga'

out_of_stock_statues = ["SOLD_OUT"]
in_stock_statues = ["ADD_TO_CART"]

best_buy_body = HTTParty.get("https://www.bestbuy.com/site/sony-playstation-5-console/6426149.p?skuId=6426149").body
best_buy_document = Oga.parse_html(best_buy_body)

best_buy_add_to_cart_button = best_buy_document.at_css('.add-to-cart-button')
best_buy_status = best_buy_add_to_cart_button.attributes.select {|attr| attr.name == "data-button-state"}[0].value
if in_stock_statues.include?(best_buy_status)
  puts "PS5 in stock order now"
else
  puts "No PS5s currently available"
end

