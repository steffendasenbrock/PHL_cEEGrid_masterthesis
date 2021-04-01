function streams = remove_zeros_eeg(streams)
%% Description

% This function removes the zeros which resulted from underruns during the
% LSL recording in openMHA

%% Function Code

% %find elemnts which have a time stamps of zero and save corresponding index
zero_element_index = find(~streams.time_stamps);
% Remove zeros from time stamps and clock corrections    
streams.time_stamps(zero_element_index) = [];
streams.clock_corrections(zero_element_index) = [];
% Split time series into channels
time_series_matrix = reshape(streams.time_series,streams.block_size,numel(streams.time_series)/streams.block_size);
% Remove all samples corresponding to zero time stamps
time_series_matrix(:,zero_element_index) = [];
% Create cleaned time series
streams.time_series = time_series_matrix(:);

end
