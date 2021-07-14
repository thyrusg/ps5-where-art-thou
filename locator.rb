require 'httparty'
require 'oga'

out_of_stock_statues = ["SOLD_OUT", "Not Available"]
in_stock_statues = ["ADD_TO_CART", "Available"]

best_buy_body = HTTParty.get("https://www.bestbuy.com/site/sony-playstation-5-console/6426149.p?skuId=6426149").body
best_buy_document = Oga.parse_html(best_buy_body)

best_buy_add_to_cart_button = best_buy_document.at_css('.add-to-cart-button')
best_buy_status = best_buy_add_to_cart_button.attributes.select {|attr| attr.name == "data-button-state"}[0].value
if in_stock_statues.include?(best_buy_status)
  puts "PS5 in stock order now"
else
  puts "No PS5s currently available"
end

gamestop_body = HTTParty.get("https://www.gamestop.com/video-games/playstation-5/consoles/products/playstation-5/11108140.html").body
gamestop_document = Oga.parse_html(gamestop_body)

gamestop_add_to_cart_button = gamestop_document.css(".add-to-cart")[0]
gamestop_status_data = gamestop_add_to_cart_button.attributes.select {|attr| attr.name == "data-gtmdata"}[0]
gamestop_status = JSON.parse(gamestop_status_data.value)["productInfo"]["availability"]

if in_stock_statues.include?(gamestop_status)
  puts "PS5 in stock order now"
else
  puts "No PS5s currently available"
end


costco_body = HTTParty.get("https://www.costco.com/sony-playstation-5-gaming-console-bundle.product.100691489.html").body
costco_document = Oga.parse_html(costco_body)

costco_add_to_cart_button = costco_document.at_css("#add-to-cart")
costco_status = !costco_add_to_cart_button.attributes.last.value.include?("out-of-stock")
if costco_status
  puts "PS5 in stock order now"
else
  puts "No PS5s currently available"
end
