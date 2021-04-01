function [import_parameters, parameters] = load_import_parameters_timing(measurement_no)
%% Description
% In this function all basic information are stored to import and process
% a particular measurement

%% Function Code

% Information about paths
import_parameters.matrix_path = './smarting_data/';
import_parameters.matrix_name = ['measurement_' num2str(measurement_no)];
import_parameters.event_matrix_path = ['./event_matrices/' 'measurement_' num2str(measurement_no) '_event_matrix'];
import_parameters.measurement_path = ['./../../data/technical_validation/scenario_1/measurement_' num2str(measurement_no) '/']; % path of data to be imported
import_parameters.buffer_size = 32; %which was used in the openMHA recording
import_parameters.number_smarting_channel = 24; %number of channels from smarting amp
import_parameters.number_audio_channel = 2; % number of audio channels
%EEGLAB
parameters.baseline_removal = true;
parameters.baseline = [-100 -50]; % in ms
parameters.timerange = [-0.1 0.15]; % in s

end
