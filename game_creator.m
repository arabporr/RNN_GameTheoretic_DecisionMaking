clc, clearvars, close all;

num_players = input('please insert the number of players : ');

num_choices = input('please insert the number of different choices : ');

choices = {}
for i = 1:num_choices
  choices(i) = input(sprintf('please enter the name of the choise with id = %d : ',i), 's')
end

best_responses = {}
for i = 1:num_choices
  best_responses(i) = input(sprintf('please enter the array of ids of the best responses to the choise = %s : ', choices{i}))
end


game_name = input('please insert the name of the game : ', 's')
save(game_name)