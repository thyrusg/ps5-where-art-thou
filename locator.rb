require 'httparty'
require 'oga'

out_of_stock_statues = ["SOLD_OUT", "Not Available", " Sold Out "]
in_stock_statues = ["ADD_TO_CART", "Available", "Add to Cart"]

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

antonline_body = HTTParty.get("https://www.antonline.com/Sony/Electronics/Gaming_Devices/Gaming_Consoles/1430137").body
antonline_document = Oga.parse_html(antonline_body)

antonline_add_to_cart_button = antonline_document.at_css(".uk-button")
antonline_status = antonline_add_to_cart_button.text

if in_stock_statues.include?(antonline_status)
  puts "PS5 in stock order now"
else
  puts "No PS5s currently available"
end
