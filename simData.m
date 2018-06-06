
function overall_wins = simData(rat_bias1, rat_bias2, rat_bias3, noise)

%% Initialize variables

% Choose starting reward probabilites fore each state
prob1start = .9;
prob2start = .5;
prob3start = .2;

% Choose a port location to start in.
start_port = 1;

% Choose value to decrement by if reward is given
decValue = .05;
%decValue = 0.95;

% choose number of trials
ntrials = 100;

% add noise
noise = .002;
rat_bias1 = .007;
rat_bias2 = .001;
rat_bias3 = .009;

%more initializing
loss_counter = [0 0 0];
win_counter = [0 0 0];
overall_wins = 0;
port_count = [0 0 0];

p1probs = zeros(length(ntrials),1);
p2probs = zeros(length(ntrials),1);
p3probs = zeros(length(ntrials),1);



% Make a vector of the probabilites.
probs = [prob1start, prob2start, prob3start];

% create cell array to store data
dataCell = {'trial', 'port', 'prob', 'reward'};

% Enter that port location.
current_port = start_port;

%% start simulation

for i = 1:ntrials

% record number of times port was chosen
port_count(current_port) = port_count(current_port) + 1;

% find probability of current state
current_prob = probs(current_port);
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
dataCell{i+1,2} = current_port; 
dataCell{i+1,3} = current_prob;
dataCell{i+1,4} = current_reward;

% for each trial, record probabilites of each port seperately.
p1probs(i,:) = probs(1);
p2probs(i,:) = probs(2);
p3probs(i,:) = probs(3);
  
% update probabilites
if current_reward == 1
    probs(current_port) = probs(current_port)-decValue;
    %probs(current_state) = probs(current_state)*decValue;
    win_counter(current_port) = win_counter(current_port) + 1;
    overall_wins = overall_wins + 1;
else
    loss_counter(current_port) = loss_counter(current_port) + 1;
    %continue
end



%% base decision on probabilites (optimal model?)

% PURE HIGHEST PROB DECISION HEURISTIC
% check which state has highest probabilities
% [~, I] = max(probs);
% move to state with highest probability
% current_state = I;

% HIGHEST PROB DECISION HEURISTIC WITH NOISE
% % check which state has highest probabilities
% % get the top two, in case rat wants to switch (noise/bias)
% [M,I] = maxk(probs,3);
% 
% % move to state with highest probability WITH NOISE AND BIAS
% % separating them into variables for debug purposes, will clean up later
% high_val = M(1);
% two_val = M(2);
% 
% if high_val - l + w < two_val
%     current_state = I(2);
% else
%     current_state = I(1);
% end


%% Win stay, lose shift (more likely to mimic actual rat behavior)

% TODO NEW CALCS:
% take in 3 rat_bias: rat_bias1,2,3 for each port
% keep loss/win counters for each port, loss_counter1, win_counter1, etc
% calculate l and w for each port: 
% ex. l2 = ((rat_bias2 + noise) * loss_counter2
% then on loss, get highest port value (port2 = w2 - l2 vs. port1, port3)
% choose highest port value as current state
% l = ((rat_bias + noise) * loss_counter);
% w = ((rat_bias + noise) * win_counter);
score_1 = ((rat_bias1 - noise) * win_counter(1)) - ((rat_bias1 + noise) * loss_counter(1));
score_2 = ((rat_bias2 - noise) * win_counter(2)) - ((rat_bias2 + noise) * loss_counter(2));
score_3 = ((rat_bias3 - noise) * win_counter(3)) - ((rat_bias3 + noise) * loss_counter(3));
if current_reward == 1
    continue
else
    % loss, switch based on calc
    % TODO do we care about what the current state is? or just the port
    % calc?
    if score_1 >= score_2 && score_1 >= score_3
        current_port = 1;
    elseif score_2 >= score_1 && score_2 >= score_3
        current_port = 2;
    else
        current_port = 3;
    end
end

end

overall_wins;

%% Plot Data

% convert data to matrix form
% dataMat = cell2mat(dataCell(2:end,:));
% % 
% X = cell2mat(dataCell(2:end,1:1));	
% Y = cell2mat(dataCell(2:end,3:3));	
% P = cell2mat(dataCell(2:end,2:2));	
% R = cell2mat(dataCell(2:end,4:4));	
% gscatter(X, Y, P, 'rgb')	
% xlabel('trials');	
% ylabel('p');
%  
% % plot data
% visFunct(dataMat)
%  
% figure
% plot(p1probs, 'o-')
% hold on
% plot(p2probs, 'o-')
% hold on
% plot(p3probs, 'o-')
% legend('Port 1','Port 2','Port 3')
% xlabel('Trial')
% ylabel('Probability of Reward')
% title('Change in the reward probability of each port per trial')
