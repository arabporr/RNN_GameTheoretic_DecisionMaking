function [result] = loop_check(stage, stages)
  
result = false;
for i = 1:length(stages)
  current = stages{i};
  if(stage == current)
    result = true;
    break;
  end
end
