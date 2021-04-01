function channel = extract_channels(streams)
%% Description
% This function splits the time series signals into structs containing
% the single channels

%% Function Code

for i=1:1:streams.block_size
    channel{i} = streams.time_series(i:streams.block_size:end);
end


end

