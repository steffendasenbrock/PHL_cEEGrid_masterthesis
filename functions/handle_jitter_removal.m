function [streams] = handle_jitter_removal(streams)
%% Description
% This function tries to reduce to the jitter of the timestamps by
% replacing them by linearly increasing timestamps with the effective
% (mean sampling rate)
% adapted from load_xdf()

for k=1:length(streams)
        
indices = [1:1:numel(streams{k}.time_stamps)];
                 
% regress out the jitter
mapping = streams{k}.time_stamps(indices)' / [ones(1,length(indices)); indices];
streams{k}.time_stamps(indices) = mapping(1) + mapping(2) * indices;

% calculate the weighted mean sampling rate over all segments
streams{k}.effective_rate = 1/mean(diff(streams{k}.time_stamps));
       
end



end