function [epoch_time_series,time_vector,absolute_point_in_time] = epoch_eeg_eeglab_marker(timing_marker,streams,epoch_bounds_ms)
%% Description

% This function creates epochs of the interpolated EEG data based on the
% extracted markers.

%% Function Code

% Fix epoch bounds
effective_srate = mean(diff(streams.time_stamps));
epoch_bounds_samples = round(epoch_bounds_ms/effective_srate);

for i=1:1:numel(timing_marker)
    %for each marker compute nearest time stamp and find index
    [M,I] = min(abs(timing_marker(i)-streams.time_stamps));
    %epoch around this index
    if (numel(streams.time_series(:)) > (I+epoch_bounds_samples(2))) && I+epoch_bounds_samples(1)>0
        epoch_time_series(:,i) = streams.time_series([(I+epoch_bounds_samples(1)):1:(I+epoch_bounds_samples(2))]);
        absolute_point_in_time(i) = timing_marker(i);
    end
end

time_vector = effective_srate*[epoch_bounds_samples(1):1:epoch_bounds_samples(2)];

end

