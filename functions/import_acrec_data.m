function [streams, parameters, import_parameters] = import_acrec_data(subject_name, run)
%% Description
% This function imports data of a given subject (1-5)
% and a given run (1-2) recorded with the openMHA plugin acrec into a
% struct of similar style as the function load_xdf().

%% Function Code

%load basic information about files to be imported
[import_parameters, parameters] = load_import_parameters(subject_name,run);

% Import acrec data
streams = import_lsl_streams(import_parameters);

% Delete Data which was not recorded properly
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

% Stream Corrections
% streams = handle_clock_synchronization_dat(streams);
% streams = handle_jitter_removal(streams);

% Manual clock correction by adding most recent time stamp
streams{1}.time_stamps = streams{1}.time_stamps+streams{1}.clock_corrections;
streams{2}.time_stamps = streams{2}.time_stamps+streams{2}.clock_corrections;

% Extract EEG data
% Save eegdata as .mat file to import into EEGLAB
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
[marker_timestamp, type] = extract_markers(streams{2}.channels{2},streams{2}.time_stamps_int);
% Offset marker time stamps
latency = [marker_timestamp-streams{1}.time_stamps(1)]';
% Define remaining parameters
% Stimulus number
number = (1:1:numel(latency))';
% duration of stimuli
duration_sound = 0.06; % duration of sound stimlulus in seconds
duration = ones(numel(latency),1)*duration_sound;
% final event matrix
event_matrix = [number type' latency duration];
% Print event matrix to txt file (later to be imported into EEGLAB)
print_matrix_to_file(event_matrix,import_parameters.event_matrix_path,'txt')
