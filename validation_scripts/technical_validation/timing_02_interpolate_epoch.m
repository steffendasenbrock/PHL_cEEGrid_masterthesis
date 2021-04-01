function [] = timing_03_interpolate_epoch()
%% Description
% This function interpolates the EEG data and extracts the corresponding
% epochs 
%% Paths

PATHIN = './eeglab_datasets/raw_data/';
PATHOUT = './eeglab_datasets/interpolated_epochs/';

%% Function Code

for measurement_no=1:1:8 % loop through all measurements

%load basic information about files to be imported
[import_parameters, parameters] = load_import_parameters_timing(measurement_no);        
% Import raw dataset 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',[import_parameters.matrix_name '.set'],'filepath',PATHIN);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% Import event marker
event_matrix = importdata(['./event_matrices/measurement_' num2str(measurement_no) '_event_matrix.txt']);
markers = event_matrix(:,3);

epoch_bounds_ms = parameters.timerange;
L=numel(EEG.data(2,:));
% Interpolate both time stamps and time series of channel to 8 kHz
EEG_interpolated.time_series = interp1(1:L,EEG.data(2,:),linspace(1,L,L*import_parameters.buffer_size));
[streams, parameters,import_parameters] = import_acrec_data_timing(measurement_no);
EEG_interpolated.time_stamps = interp1(1:L,(streams{1,1}.time_stamps-streams{1,1}.time_stamps(1)),linspace(1,L,L*import_parameters.buffer_size));
% Calculate Epochs
[EEG.epoch_time_series,EEG.epoch_time_vector,EEG.absolute_point_in_time] = epoch_eeg_eeglab_marker(markers,EEG_interpolated,epoch_bounds_ms);
% Store data
save([PATHOUT '/measurement_' num2str(measurement_no)],'EEG')

end

end