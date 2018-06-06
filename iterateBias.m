% This might be ti iterate across multiple bias values?
j=0;
wins = [];
num_iterations = 50;
noise = .001;
tic
rat_bias_values = [0:5:100];
for j=1:length(rat_bias_values)
    rat_bias = rat_bias_values(j);
    for k=1:num_iterations
        wins(j,k) = simData(rat_bias, 0.001, 0.007, noise);
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
