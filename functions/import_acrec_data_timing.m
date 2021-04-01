function [streams, parameters, import_parameters] = import_acrec_data_timing(measurement_no)
%% Description
% This function imports LSL data recorded using openMHA plugin acrec into a
% struct of similar style as the conventional function load_xdf() used for
% xdf. data. The single channels are extracted from the data and the time
% stamps are corrected by adding the most recent time stamps

%% Function Code

%load basic information about files to be imported
[import_parameters, parameters] = load_import_parameters_timing(measurement_no);

% Import data recording with acrec
streams = import_lsl_streams(import_parameters);

% % Delete Data which was not recorded properly
streams{1} = delete_smarting_data(streams{1});
streams{2} = delete_openMHA_data(streams{2});

% Remove zeros which were generated due to underruns in the ac2lsl plugin
streams{2} = remove_zeros(streams{2});
streams{1} = remove_zeros_eeg(streams{1});

% Remove last block of size buffer_size*number_of_audio_channels from openMHA
% time series for interpolation purposes
streams{2}.time_series = streams{2}.time_series(1:end-import_parameters.number_audio_channel*import_parameters.buffer_size);

% Extract Audio and EEG Channels
streams{1}.eeg_channels = extract_channels(streams{1});
streams{2}.channels = extract_channels(streams{2});

% Manual clock correction by adding most recent time stamp
streams{1}.time_stamps = streams{1}.time_stamps+streams{1}.clock_corrections;
streams{2}.time_stamps = streams{2}.time_stamps+streams{2}.clock_corrections;

% Extract EEG data
% Save eegdata as .mat file to be imported into EEGLAB
eeg_matrix = [];
for i=1:1:24
eeg_matrix = [eeg_matrix streams{1}.eeg_channels{i}];
end
S.eeg_matrix_1 = eeg_matrix;
% Output matrix containing EEG data as temporary file (later to be 
% imported into EEGLAB)
save([import_parameters.matrix_path import_parameters.matrix_name '.mat'],'-struct','S')

% Event Markers
%Interpolate openMHA time stamps
streams{2}.time_stamps_int = interpolate_openmha_data_2(streams{2}.time_stamps, import_parameters.buffer_size);
%extract markers
marker_times = find_rising_edges(streams{2}.time_stamps_int,streams{2}.channels{1},true);
type = ones(1,numel(marker_times));
%[marker_timestamp, type] = extract_timing_markers(streams{2}.channels{1},streams{2}.time_stamps_int);
% Offset marker time stamps
% Since time in EEGLAB is referenced to EEG beginning time
latency = [marker_times-streams{1}.time_stamps(1)]';
% Define remaining parameters
% Stimulus number
number = (1:1:numel(latency))';
% duration of stimuli
duration_sound = 0.06; % duration of sound stimlulus in seconds (is not used later)
duration = ones(numel(latency),1)*duration_sound;
% final event matrix
event_matrix = [number type' latency duration];
% Print event matrix to txt file (later to be imported into EEGLAB)
print_matrix_to_file(event_matrix,import_parameters.event_matrix_path,'txt')
