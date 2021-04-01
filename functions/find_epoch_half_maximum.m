function [rising_edges,maximum_height,epoch_measured] = find_epoch_half_maximum(epoch_time_series,time_vector,dy)
%% Description
% This function find the rising edge, defined as the point, where the 
% signal exceeds half of the maximum value with reference to the average
% epoch value

epoch_measured = zeros(1,size(epoch_time_series,2));

for i=1:1:size(epoch_time_series,2)

epoch = epoch_time_series(:,i);
average_epoch = mean(epoch);
zero_mean_epoch = epoch-average_epoch;
idx = find(zero_mean_epoch > max(zero_mean_epoch)/2);
if average_epoch ~= 0
rising_edges(i) = time_vector(idx(1));
maximum_height(i) = zero_mean_epoch(idx(1));
epoch_measured(i) = true;

end
end

end