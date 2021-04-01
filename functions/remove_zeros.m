function streams = remove_zeros(streams)
%% Description

% This function removes the zeros which resulted from underruns during the
% LSL recording in openMHA

%% Function Code

%find elemnts which have a time stamps of zero and save corresponding index
zero_element_index = find(~streams.time_stamps);

if ~isempty(zero_element_index)

% Remove zeros from time stamps and clock corrections    
streams.time_stamps(zero_element_index) = [];
streams.clock_corrections(zero_element_index) = [];

% All blocks corresponding to these time stamps also need to be removed
% split signal into number of channels
time_series_matrix = reshape(streams.time_series,streams.block_size,numel(streams.time_series)/streams.block_size);

% Split signal into blocks of buffer size to remove corresponding blocks
for i=1:1:streams.block_size
    channel{i} = time_series_matrix(i,:);
    channel_reshape{i} = reshape(channel{i}, [streams.buffer_size numel(channel{i})/streams.buffer_size]);
    channel_reshape{i}(:,zero_element_index) = [];
end

% Generate clean time series 
time_series_matrix = [];
for i=1:1:streams.block_size
    time_series_matrix = [time_series_matrix channel_reshape{i}(:)];
end

transpose_time_series=time_series_matrix';
streams.time_series=transpose_time_series(:);
    
end

streams.time_series = streams.time_series';

end
