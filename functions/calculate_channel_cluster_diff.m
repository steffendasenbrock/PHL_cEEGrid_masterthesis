function [channel_diff, mean_channel_diff] = calculate_channel_cluster_diff(channel_cluster_1,channel_cluster_2,eeg_data)

%% Description
% This function calculates the difference between two cluster of channels
% cluster is referred to multiple channels, the mean for both is calculated
% and substracted from each other.

%% Function Code

% Calculate cluster means
mean_cluster_1    = mean(eeg_data(channel_cluster_1,:,:),1);
mean_cluster_2    = mean(eeg_data(channel_cluster_2,:,:),1);
% Substract cluster mean from each other
channel_diff      = mean_cluster_1-mean_cluster_2;
% Average over all epochs
mean_channel_diff = mean(channel_diff,3);

end
