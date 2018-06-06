function [] = visFunct(dataMat)
%visFunct takes in a matrix of data with trial number in first column and
%probability of reward in second column.
%   Detailed explanation goes here
state1 = [];
state2 = [];
state3 = [];

for i = 1:length(dataMat)

if dataMat(i,2) == 1
    state1 = [state1; dataMat(i,:)];
elseif dataMat(i,2) == 2
    state2 = [state2; dataMat(i,:)];
elseif dataMat(i,2) == 3
    state3 = [state3; dataMat(i,:)];
else
    break
end

end


figure
plot(state1(:,1),state1(:,3), 'o-')
hold on
plot(state2(:,1),state2(:,3), 'o-')
hold on
plot(state3(:,1),state3(:,3), 'o-')

legend('Port 1','Port 2','Port 3')
xlabel('Trial')
ylabel('Probability of Reward')
title('Change in the reward probability of each port per trial')
end

% 
%     if dataMat(i,2) == 1
%     state1(i,:) = [dataMat(i,1), dataMat(i,3)];
% else state1(i,:) = [dataMat(i,1), dataMat(i-1,3)];
% 
% 
% if dataMat(i,2) == 2
%     state2(i,:) = [dataMat(i,1), dataMat(i,3)];
% else state2(i,:) = [dataMat(i,1), dataMat(i-1,3)];
% 
% 
% if dataMat(i,2) == 3
%     state3(i,:) = [dataMat(i,1), dataMat(i,3)];
% else state3(i,:) = [dataMat(i,1), dataMat(i-1,3)];
% 
