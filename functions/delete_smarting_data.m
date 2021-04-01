function [streams] = delete_smarting_data(streams)
%% Description
% This function checks, if some data is missing in the end of a recording.
% If yes, it reduces the data such that the remaining data is complete.

%% Function Code

if(numel(streams.time_stamps)*streams.block_size<numel(streams.time_series))

target_samples = numel(streams.time_stamps)*streams.block_size;
streams.time_series(target_samples+1:end) = [];

elseif(numel(streams.time_stamps)*streams.block_size>numel(streams.time_series))
    
    target_samples = numel(streams.time_series)/streams.block_size;
    streams.time_stamps(target_samples+1:end) = [];
    streams.clock_corrections(target_samples+1:end) = [];

end


end
