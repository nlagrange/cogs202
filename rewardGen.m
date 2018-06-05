function [reward] = rewardGen(probability)
%UNTITLED2 Summary of this function goes here
%   make sure probability input is in decimal form.


x=rand;
if x<probability
  reward=1;
else
  reward=0;
end

end

