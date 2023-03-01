clc, clearvars, close all;

game_name = input('please insert the name of the game : ', 's')
load(game_name)

stages = {};
stage = ones(num_players, num_choices);

counter = 0;
update_limit = 10^5;

while((loop_check(stage, stages) == false) && (counter < update_limit))
  stages{end+1} = stage;
  counter = counter + 1;
  stage = stage_update(stage, best_responses, num_players, num_choices);
end


unique_equilibrium = true;
for player = 1:num_players
  if(sum(stages{end}(player,:)) > 1)
    unique_equilibrium = false;
    break;
  end;
end;

if(stage == stages{end})
  if(unique_equilibrium == true)
    disp('Geat !, This game has unique nash equilibrium')
    disp('The game will end with this result matrix :')
    disp(stages{end})
    stage_plot(stages{end}, best_responses, choices, num_players, num_choices)
  else
    disp('The game might have multiple nash equilibrium or nothing based on its choices')
    disp('The game will end with this result matrix :')
    disp(stages{end})
    stage_plot(stages{end}, best_responses, choices, num_players, num_choices)
  end
elseif (counter != update_limit)
  disp('Unfortunately, the game has no nash equilibrium !')
else
  disp('Error! we ran out of computation !')
end

