function [marker_timestamp, marker] = extract_markers(openMHA_marker_int,openMHA_ts_int)
%% Description

% This function extracts the oddball markers from the second openMHA LSL
% channel.

%% Input Variables

% openMHA_marker_int = Second openMHA channel
% openMHA_ts_int     = Corresponding interpolated time stamp vector

%% Code

% Find all the different marker types
different_markers = unique(openMHA_marker_int);
% Find all the markers types equal to zero
zero_markers = find(openMHA_marker_int==different_markers(1));
% Discard every zero elements 
marker = openMHA_marker_int;
marker(zero_markers) = [];
% Normalize marker vector such on "1" and "2" markers
marker = round(marker/different_markers(2));
% Repeat for marker timestamp
marker_timestamp = openMHA_ts_int;
%marker_timestamp(zero_markers) = 10;
marker_timestamp(zero_markers) = [];
end
