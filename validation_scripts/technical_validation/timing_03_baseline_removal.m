function [] = timing_04_baseline()
%% Description
% This function removes the baseline of the extracted epochs
%% Paths

PATHIN = './eeglab_datasets/interpolated_epochs/';
PATHOUT = './eeglab_datasets/baseline_corrected/';

%% Function Code

for measurement_no=1:1:8 % loop through all measurements
    
% load parameters    
[import_parameters, parameters] = load_import_parameters_timing(measurement_no);        
% load dataset    
load([PATHIN '/measurement_' num2str(measurement_no)])
% search for data baseline values in time vector
[M_1,I_1] = min(abs(parameters.baseline(1)-EEG.epoch_time_vector*1000));
[M_2,I_2] = min(abs(parameters.baseline(2)-EEG.epoch_time_vector*1000));
% substrat baseline
EEG.epoch_time_series = EEG.epoch_time_series-mean(EEG.epoch_time_series(I_1:I_2,:));
% Calculate Rising Edges
[EEG.time_rising_edges, maximum_height,EEG.epoch_measured] = find_epoch_half_maximum(EEG.epoch_time_series,EEG.epoch_time_vector,true);
% Store data
save([PATHOUT '/measurement_' num2str(measurement_no)],'EEG')

end

end