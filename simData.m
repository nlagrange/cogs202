function win_counter = simData(rat_bias, noise)
%% Initialize variables

% Choose starting reward probabilites fore each state

port1start = .9;
port2start = .5;
port3start = .2;

% Choose a state (port location) to start in.
start_state = 1;

% Choose value to decrement by if reward is given
decValue = .05;
%decValue = 0.95;

% choose number of trials
ntrials = 100;

% add noise
noise = .002;
rat_bias = .007;
loss_counter = [0 0 0];
win_counter = [0 0 0];

%% Simulate Data
% Make a vector of the probabilites.
probs = [port1start, port2start, port3start];

% create cell array to store data
dataCell = {'trial', 'port', 'prob', 'reward'};

% Enter that state (port location).
current_state = start_state;

%initialize
p1probs = [];
p2probs = [];
p3probs = [];

for i = 1:ntrials

% find probability of current state
current_prob = probs(current_state);
% produce a reward or non-reward
current_reward = rewardGen(current_prob);
% current_reward = binornd(1,current_prob); % Equivalent

% % insert values into a structure. (used cell array instead see below).
% data.i = i;
% data.i.port = current_state;
% data.i.prob = current_prob;
% data.i.reward = current_reward;

% instert values into cell array
dataCell{i+1,1} = i; 
dataCell{i+1,2} = current_state; 
dataCell{i+1,3} = current_prob;
dataCell{i+1,4} = current_reward;

% for each trial, record probabilites of each port seperately.
p1probs(i,:) = [probs(1)];
p2probs(i,:) = [probs(2)];
p3probs(i,:) = [probs(3)];
  
% update probabilites
if current_reward == 1
    probs(current_state) = probs(current_state)-decValue;
    %probs(current_state) = probs(current_state)*decValue;
    win_counter(current_state) = win_counter(current_state) + 1;
else
    loss_counter(current_state) = loss_counter(current_state) + 1;
    %continue
end

% check which state has highest probabilities
% [~, I] = max(probs);
% move to state with highest probability
% current_state = I;

% check which state has highest probabilities
% get the top two, in case rat wants to switch (noise/bias)
[M,I] = maxk(probs,3);

% move to state with highest probability WITH NOISE AND BIAS
% separating them into variables for debug purposes, will clean up later
high_val = M(1);
two_val = M(2);

% TODO NEW CALCS:
% take in 3 rat_bias: rat_bias1,2,3 for each port
% keep loss/win counters for each port, loss_counter1, win_counter1, etc
% calculate l and w for each port: 
% ex. l2 = ((rat_bias2 + noise) * loss_counter2
% then on loss, get highest port value (port2 = w2 - l2 vs. port1, port3)
% choose highest port value as current state
% l = ((rat_bias + noise) * loss_counter);
% w = ((rat_bias + noise) * win_counter);
score_1 = ((rat_bias - noise) * win_counter(1)) - ((rat_bias + noise) * loss_counter(1));
score_2 = ((rat_bias - noise) * win_counter(2)) - ((rat_bias + noise) * loss_counter(2));
score_3 = ((rat_bias - noise) * win_counter(3)) - ((rat_bias + noise) * loss_counter(3));
if current_reward == 1
    continue
else
    % loss, switch based on calc
    % TODO do we care about what the current state is? or just the port
    % calc?
    if score_1 >= score_2 && score_1 >= score_3
        current_state = 1;
    elseif score_2 >= score_1 && score_2 >= score_3
        current_state = 2;
    else
        current_state = 3;
    end
end
% if high_val - l + w < two_val
%     current_state = I(2);
% else
%     current_state = I(1);
% end
end

% convert data to matrix form
dataMat = cell2mat(dataCell(2:end,:));

 X = cell2mat(dataCell(2:end,1:1));	
 Y = cell2mat(dataCell(2:end,3:3));	
 P = cell2mat(dataCell(2:end,2:2));	
 R = cell2mat(dataCell(2:end,4:4));	
 gscatter(X, Y, P, 'rgb')	
 xlabel('trials');	
 ylabel('p');
 
% plot data
 visFunct(dataMat)
 
 figure
 plot(p1probs, 'o-')
 hold on
 plot(p2probs, 'o-')
 hold on
 plot(p3probs, 'o-')