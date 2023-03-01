function [stage] = stage_update(stage, best_responses, num_players, num_choices)

temp_stage = zeros(num_players, num_choices);

for current_player = 1:num_players
  for current_choice = 1:num_choices
    if(stage(current_player, current_choice) == 1)
      for other_player = 1:num_players
        if(other_player != current_player)
          for others_response = 1:length(best_responses{current_choice})
              temp_stage(other_player, best_responses{current_choice}(others_response)) = 1;
          endfor
        end
      endfor
    end
  endfor
end

stage = temp_stage;