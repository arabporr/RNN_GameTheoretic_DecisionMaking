function [graph] = stage_plot(stage, best_responses, choices, num_players, num_choices)


nodes = 1:(num_players*num_choices);
nodes_labels = [];
for player = 1:num_players
  for choice = 1:num_choices
    index = (player-1)*(num_choices) + choice;
    temp_str = sprintf("player %d, choice %d", player, choice);
    node_labels{index} = temp_str;
  endfor
end

G = digraph(nodes);

for current_player = 1:num_players
  for current_choice = 1:num_choices
    if(stage(current_player, current_choice) == 1)
      for other_player = 1:num_players
        if(other_player != current_player)
          for others_response = 1:length(best_responses{current_choice})
            head_node = ((other_player-1)*(num_choices) + best_responses{current_player}(others_response));
            tail_node = ((current_player-1)*(num_choices) + current_choice);
            G = addedge(G, head_node, tail_node);
          endfor
        end
      endfor
    end
  endfor
end

plot(G, '-or', 'Layout', 'force', 'NodeLabel', node_labels{:})