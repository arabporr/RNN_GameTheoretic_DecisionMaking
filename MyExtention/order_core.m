function [change_in_price, round_trades, round_volume] = order_core(orders)
global number_of_rounds number_of_players last_price players_money players_asset diff_of_prices buy_list sell_list

change_in_price = 0;
round_trades = 0;
round_volume = 0;

buy_list = [];
sell_list = [];

for person = 1:number_of_players
  order = orders{person};
  if(order(4) == 1)
    buy_list = [buy_list; order(1), order(2), order(3)];
  elseif(order(4) == 2)
    sell_list = [sell_list; order(1), order(2), order(3)];
  end
end

if(size(buy_list, 1) > 1)
  buy_list = sortrows(buy_list, 2);
end
if(size(sell_list, 1) > 1)
  sell_list = sortrows(sell_list, 2);
end


current_price = last_price;
buyer_index = 1;
seller_index = 1;

while((size(buy_list, 1) > 0) && (size(sell_list, 1) > 0) && (buyer_index <= size(buy_list, 1)) && (seller_index <= size(sell_list, 1)))
  buyer = buy_list(buyer_index, 1);
  buyer_price = buy_list(buyer_index, 2);
  buyer_order_value = buy_list(buyer_index, 3);
  buyer_order_volume = buyer_order_value / buyer_price;
  
  seller = sell_list(seller_index, 1);
  seller_price = sell_list(seller_index, 2);
  seller_order_volume = sell_list(seller_index, 3);
  seller_order_value = seller_order_volume * seller_price;
  
  
  if(buyer_price < seller_price)
    buyer_index = buyer_index + 1;
  else  
    if(buyer_order_volume >= seller_order_volume)
      round_volume = round_volume + seller_order_volume;
      
      buyer_order_volume = buyer_order_volume - seller_order_volume;
      buyer_order_value = buyer_order_value - (seller_order_volume * buyer_price);
      buy_list(buyer_index, 3) = buyer_order_value;
      
        
      players_money(buyer) = players_money(buyer) - (seller_order_volume * buyer_price);
      players_asset(buyer) = players_asset(buyer) + seller_order_volume;
      players_money(seller) = players_money(seller) + (seller_order_volume * seller_price);
      players_asset(seller) = players_asset(seller) - seller_order_volume;
      
      diff_of_prices = diff_of_prices + seller_order_volume*(buyer_price-seller_price);
      current_price = buyer_price;
      
      seller_order_volume = 0;
      seller_order_value = seller_order_volume * seller_price;
      sell_list(seller_index, 3) = seller_order_volume;
      
      seller_index = seller_index + 1;
    else
      round_volume = round_volume + buyer_order_volume;
      
      seller_order_volume = seller_order_volume - buyer_order_volume;
      seller_order_value = seller_order_volume * seller_price;
      sell_list(seller_index, 3) = seller_order_volume;
      
      players_money(buyer) = players_money(buyer) - (buyer_order_volume * buyer_price);
      players_asset(buyer) = players_asset(buyer) + buyer_order_volume;
      players_money(seller) = players_money(seller) + (buyer_order_volume * seller_price);
      players_asset(seller) = players_asset(seller) - buyer_order_volume;
      
      diff_of_prices = diff_of_prices + buyer_order_volume*(buyer_price-seller_price);
      current_price = buyer_price;
      
      buyer_order_volume = 0;
      buyer_order_value = 0;
      buy_list(buyer_index, 3) = 0;
      
      buyer_index = buyer_index + 1;
    end
  end
  
  round_trades = round_trades + 1;
end
  
change_in_price = current_price - last_price;