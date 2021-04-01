function [streams] = import_lsl_streams(import_parameters)
%% Description
% This function imports LSL data recorded using openMHA plugin acrec into a
% struct of similar style as the conventional function load_xdf() used for
% xdf. data

%% Function Code

measurement_data_info = dir([import_parameters.measurement_path '*.dat']);

% Import Smarting data
streams{1}.time_series = import_dat_file([import_parameters.measurement_path measurement_data_info(5).name]);
streams{1}.time_stamps = import_dat_file([import_parameters.measurement_path measurement_data_info(6).name]);
streams{1}.clock_corrections = import_dat_file([import_parameters.measurement_path measurement_data_info(4).name]);
streams{1}.block_size = import_parameters.number_smarting_channel;

% Import openMHA data 
streams{2}.time_series = import_dat_file([import_parameters.measurement_path measurement_data_info(2).name]);
streams{2}.time_stamps = import_dat_file([import_parameters.measurement_path measurement_data_info(3).name]);
streams{2}.clock_corrections = import_dat_file([import_parameters.measurement_path measurement_data_info(1).name]);
streams{2}.block_size = import_parameters.number_audio_channel;
streams{2}.buffer_size = import_parameters.buffer_size;

end