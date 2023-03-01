clc, clearvars, close all;
global number_of_rounds number_of_players last_price players_money players_asset diff_of_prices buy_list sell_list

number_of_rounds = input('please enter the number of rounds of simulation : ');
number_of_players = input('please enter the number of players : ');
average_money = input('please insert the average money people have at beginning : ');
average_asset = input('please insert the average shares poeple have at beginning : ');
last_price = input('please enter the initial price for asset : ');
sentimnet_effect = input('Do you want to consider random market sentimnet ? (1 for yes, 0 for no) ');
if(sentimnet_effect)
  sentiments_shift = input('enter the big picture sentiments (or 0 to ignore) : ');
  sentiments_multiplier = input('enter the sentiments effect multiplier (or 1 to ignore) : ');
  sentiments = (randn(1, number_of_rounds) + sentiments_shift) + sentiments_multiplier;
end


diff_of_prices = 0;

players_money = abs(randn(1, number_of_players)) .* average_money;
players_asset = abs(randn(1, number_of_players)) .* average_asset;

history_of_price = [last_price];
history_of_trades = [0];
history_of_volume = [0];
history_of_average_money = [average_money];
history_of_average_asset = [average_asset];
history_of_players_money = {players_money};
history_of_players_asset = {players_asset};
round_result = {};

people_initial_state = zeros(number_of_players, 1);
for person = 1:number_of_players
  people_initial_state(person) = people_initial_state(person) + players_money(person);
  people_initial_state(person) = people_initial_state(person) + players_asset(person)*last_price;
end

round = 1;
while(round <= number_of_rounds)
  if(sentimnet_effect == 1)
    sentimnet = sentiments(round);
  else
    sentimnet = 0;
  end
  
  orders = {};
  
  for person = 1:number_of_players
    value_for_person = (((randn(1) + sentimnet)/100)+1);
    value_for_person = value_for_person * last_price;
    order_percentage = rand(1);
    order_type = randi(4);
        
    if((order_type == 1) && (players_money(person) > 0))
      orders{person} = [person, value_for_person, order_percentage*players_money(person), order_type];
    elseif((order_type == 2) && (players_asset(person) > 0))
      orders{person} = [person, value_for_person, order_percentage*players_asset(person), order_type];
    else
      orders{person} = [person, last_price, 0, 0];
    end
    
  endfor
    
  [change_in_price, round_trades, round_volume] = order_core(orders);
  last_price = last_price + change_in_price;
  history_of_price(end+1) = last_price;
  history_of_trades(end+1) = round_trades;
  history_of_volume(end+1) = round_volume;
  history_of_average_money(end+1) = mean(players_money);
  history_of_average_asset(end+1) = mean(players_asset);
  history_of_players_money{end+1} = players_money;
  history_of_players_asset{end+1} = players_asset;
  round_result{end+1} = sprintf("Round %d; change in price = %d, number of trades = %d, total volume of trades %d dollars", round, change_in_price, round_trades, round_volume);
  round = round + 1;
end

people_final_state = zeros(number_of_players, 1);
for person = 1:number_of_players
  people_final_state(person) = people_final_state(person) + players_money(person);
  people_final_state(person) = people_final_state(person) + players_asset(person)*last_price;
end

people_change = people_final_state - people_initial_state;

rounds = 0:number_of_rounds;

figure(1)

subplot(1,1,1)
plot(rounds, history_of_price)
xlabel('Rounds'), ylabel('Price'), title('History of price')
grid on


round_print = input('do you want to see the details for each round ? (1 for yes, 0 for no) ');
if(round_print)
  disp(round_result);
end


more_stats = input('do you want more market statistics ? (1 for yes, 0 for no) ');
if(more_stats)
  figure(2)

  subplot(1,3,1)
  plot(rounds, history_of_volume)
  xlabel('Rounds'), ylabel('Volume'), title('Total volume per round')
  grid on

  subplot(1,3,2)
  plot(rounds, history_of_trades)
  xlabel('Rounds'), ylabel('Trades'), title('Number of trades per round')
  grid on

  subplot(1,3,3)
  plot(rounds, (history_of_volume./history_of_trades))
  xlabel('Rounds'), ylabel('Avg. Vol/Trade'), title('Average volume per trade')
  grid on
end

people_stats = input('do you want more statistics about people ? (1 for yes, 0 for no) ');
if(people_stats)
  figure(3)

  subplot(3,2,1)
  plot(rounds, history_of_average_money)
  xlabel('Rounds'), ylabel('Money'), title('Average money per person')
  grid on

  subplot(3,2,2)
  plot(rounds, history_of_average_asset)
  xlabel('Rounds'), ylabel('Assets'), title('Average asset per person')
  grid on
  
  subplot(3,2,3)
  hist(history_of_players_asset{1})
  xlabel('person id'), ylabel('Assets'), title('Initial players asset distribution')
  grid on
  
  subplot(3,2,4)
  hist(history_of_players_money{1})
  xlabel('person id'), ylabel('Money'), title('Initial players money distribution')
  grid on
  
  subplot(3,2,5)
  hist(history_of_players_asset{end})
  xlabel('person id'), ylabel('Assets'), title('Final players asset distribution')
  grid on
  
  subplot(3,2,6)
  hist(history_of_players_money{end})
  xlabel('person id'), ylabel('Money'), title('Final players money distribution')
  grid on
  
  figure(4)
  hist(people_change)
  xlabel('the change amount'), ylabel('Total wealth'), title('players wealth change distribution')
  grid on
end


disp(['The broker has made : ', num2str(diff_of_prices), 'dollars !']);
disp(['the greatest winner had made ' num2str(max(people_change)), ' dollars!']);
disp(['the greatest loser had lost ' num2str(min(people_change)), ' dollars!']);
disp(['the average change people have made was ' num2str(mean(people_change)), ' dollars!']);

