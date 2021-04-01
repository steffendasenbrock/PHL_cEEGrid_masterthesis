function [time_rising_edges] = find_rising_edges(time_vector,signal,dy)
%% Description
% This function finds the rising edges of a signal and gives back the time
% stamps of the rising edges as a vector 

%% Input variables
% time_vector   = time stamp vector of signal
% signal        = corresponding signal
% dy            = if true, use deriviate, else signal itself

%% Code 

% Take derivative of signal 
if dy ==true
signal_dy(:) = gradient(signal(:), 1);
else
signal_dy(:) = signal(:);
end

% Find slope values max_dy and corresponding indices max_dy_index of
% derivative signal
max_values = maxk(signal_dy(:),20);
[~,max_dy_index] = findpeaks(signal_dy(:),'MinPeakDistance',10,'MinPeakHeight',max_values(end)/2);
time_rising_edges(:) = time_vector(max_dy_index);
end
