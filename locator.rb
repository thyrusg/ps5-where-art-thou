require 'httparty'
require 'oga'
require 'json'



def notify_discord(message)
  discord_user_id = ENV["DISCORD_USER_ID"].to_i
  discord_webhook_url = ENV["DISCORD_WEBHOOK_URL"]
  discord_mention_string = "<@#{discord_user_id}>"
  headers = {"Content-Type"=>"application/json"}
  body = {:content=>"#{message} #{discord_mention_string}", :allowed_mentions=>{:users=>["#{discord_user_id}"]}}
  HTTParty.post(discord_webhook_url, headers: headers, body: body.to_json)
end

out_of_stock_statues = ["SOLD_OUT", "Not Available", " Sold Out "]
in_stock_statues = ["ADD_TO_CART", "Available", "Add to Cart"]

best_buy_url = "https://www.bestbuy.com/site/sony-playstation-5-console/6426149.p?skuId=6426149"
best_buy_body = HTTParty.get(best_buy_url).body
best_buy_document = Oga.parse_html(best_buy_body)

best_buy_add_to_cart_button = best_buy_document.at_css('.add-to-cart-button')
best_buy_status = best_buy_add_to_cart_button.attributes.select {|attr| attr.name == "data-button-state"}[0].value
if in_stock_statues.include?(best_buy_status)
  puts "BB: PS5 in stock order now"
else
  puts "BB: No PS5s currently available"
  notify_discord("PS5 Available at Best Buy")
end

gamestop_url = "https://www.gamestop.com/video-games/playstation-5/consoles/products/playstation-5/11108140.html"
gamestop_body = HTTParty.get(gamestop_url).body
gamestop_document = Oga.parse_html(gamestop_body)

gamestop_add_to_cart_button = gamestop_document.css(".add-to-cart")[0]
gamestop_status_data = gamestop_add_to_cart_button.attributes.select {|attr| attr.name == "data-gtmdata"}[0]
gamestop_status = JSON.parse(gamestop_status_data.value)["productInfo"]["availability"]

if in_stock_statues.include?(gamestop_status)
  puts "GS: PS5 in stock order now"
else
  puts "GS: No PS5s currently available"
end

sony_url = "https://direct.playstation.com/en-us/consoles/console/playstation5-console.3005816"
sony_body = HTTParty.get(sony_url).body
sony_document = Oga.parse_html(sony_body)

sony_add_to_cart_button = sony_document.at_css(".add-to-cart")
sony_button_hidden = sony_add_to_cart_button.attributes.select {|attr| attr.name == "class"}[0].value.include?("hide")
sony_status = !sony_button_hidden

if sony_status
  puts "S: PS5 in stock order now"
else
  puts "S: No PS5s currently available"
end

antonline_url = "https://www.antonline.com/Sony/Electronics/Gaming_Devices/Gaming_Consoles/1430137"
antonline_body = HTTParty.get(antonline_url).body
antonline_document = Oga.parse_html(antonline_body)

antonline_add_to_cart_button = antonline_document.at_css(".uk-button")
antonline_status = antonline_add_to_cart_button.text

if in_stock_statues.include?(antonline_status)
  puts "PS5 in stock order now"
else
  puts "No PS5s currently available"
end
