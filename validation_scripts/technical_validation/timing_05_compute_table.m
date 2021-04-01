function [] = timing_07_compute_table()

%% Description
% This function extracts all the parameters used to evaluate the timing
% behaviour of the setup (lag, jitter, drift) and puts them into a table
% sorted by the amount of lag 
%% Paths

PATHIN = './eeglab_datasets/baseline_corrected/';
PATHOUT = './eeglab_datasets/plots/';

%% Function Code

for measurement_no=1:1:8 % loop through all measurements
    
% load parameters    
[import_parameters, parameters] = load_import_parameters_timing(measurement_no);        
% load dataset    
load([PATHIN '/measurement_' num2str(measurement_no)]);
% plot mean epoch
[~, index] = find(EEG.absolute_point_in_time);

lag(measurement_no) = mean(EEG.time_rising_edges(index)*1000)
jitter(measurement_no) = std(EEG.time_rising_edges(index)*1000)

X = [ones(length(EEG.absolute_point_in_time(index)),1) EEG.absolute_point_in_time(index)'];
b = X\(EEG.time_rising_edges(index)*1000)';
drift(measurement_no) = b(2)*60 %ms/60s
total_shift(measurement_no) = (EEG.absolute_point_in_time(end)*b(2)+b(1))-(EEG.absolute_point_in_time(1)*b(2)+b(1))
end

%Remove 0s from measurements
table_index = find(lag)
lag = lag(table_index)
jitter = jitter(table_index)
drift = drift(table_index)
total_shift = total_shift(table_index)
[~, table_index] = sort(lag)
table_index=flip(table_index)
TABLE = [lag(table_index)' jitter(table_index)' drift(table_index)' total_shift(table_index)']
TABLE_thesis = round(TABLE,2)

end