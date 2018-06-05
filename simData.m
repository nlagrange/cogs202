%% Initialize variables

% Choose starting reward probabilites fore each state

port1start = .9;
port2start = .5;
port3start = .2;

% Choose a state (port location) to start in.
start_state = 1;

% Choose value to decrement by if reward is given
decValue = .05;

% choose number of trials
ntrials = 100;
%% Simulate Data
% Make a vector of the probabilites.
probs = [port1start, port2start, port3start];
noise = .001;
rat_bias = .007;
losses = 0;
wins = 0;
early_switch = 0;
% create cell array to store data
data = {'trial', 'port', 'prob', 'reward'};

% Enter that state (port location).
current_state = start_state;

for i = 1:ntrials

% find probability of current state
current_prob = probs(current_state);
% produce a reward or non-reward
current_reward = rewardGen(current_prob);

% % insert values into a structure. (used cell array instead see below).
% data.i = i;
% data.i.port = current_state;
% data.i.prob = current_prob;
% data.i.reward = current_reward;

% instert values into cell array
data{i+1,1} = i; 
data{i+1,2} = current_state; 
data{i+1,3} = current_prob;
data{i+1,4} = current_reward;

% update probabilites
if current_reward == 1
    probs(current_state) = probs(current_state)-.05;
    losses = 0;
    wins = wins+1;
else
    losses = losses+1;
    wins = 0;
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
loss = (rat_bias + noise) * losses;
win = (rat_bias + noise) * wins;
if high_val - loss + win < two_val
    current_state = I(2);
else
    current_state = I(1);
end
end

