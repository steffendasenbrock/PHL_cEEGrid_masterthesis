function [openMHA_ts_int] = interpolate_openmha_data_2(openMHA_ts, buffer_size)
%% Description

% This function performs an interpolation of the openMHA LSL timestamps
% which were initially sent for only each block of signal

%% Function Code

% interpolate time stamps
L=numel(openMHA_ts);
% here the beginning of each buffer block is connected to each timestamp
openMHA_ts_int = zeros(1,(numel(openMHA_ts)-1)*buffer_size);
openMHA_ts_int = interp1(1:L,openMHA_ts,linspace(1,L-1/buffer_size,(L-1)*buffer_size));

end