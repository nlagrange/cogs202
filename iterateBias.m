% This might be ti iterate across multiple bias values?
j=0;
wins = [];
num_iterations = 50;
noise = .1;
tic
rat_bias_values = [0:.05:1];
for j=1:length(rat_bias_values)
%     using rat_bias for noise
    rat_bias = rat_bias_values(j);
    for k=1:num_iterations
        wins(j,k) = simData(0.1, 0.01, 0.001, rat_bias);
        [j,k]
        toc
    end
end

mean_wins = mean(wins,2);
sd_wins = std(wins,[],2);

%%

plot(rat_bias_values, mean_wins, 's-')
hold on
errorbar(rat_bias_values, mean_wins, sd_wins, 's-')
hold off
