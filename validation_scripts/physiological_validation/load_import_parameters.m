function [import_parameters, parameters] = load_import_parameters(subject_name,run)
%% Description
% In this function all basic information are stored which can be extracted
% from the subject's name and run

%% Function Code

% Information about paths
import_parameters.matrix_path = './eeg_data/';
import_parameters.matrix_name = ['subject_no_' num2str(subject_name) '_run_' num2str(run) ];
import_parameters.event_matrix_path = ['./event_matrices/' 'subject_no_' num2str(subject_name) '_run_' num2str(run) '_event_matrix'];
import_parameters.measurement_path = ['./../../data/physiological_validation/subject_no_' num2str(subject_name) '/run_' num2str(run) '/']; % path of data to be imported
import_parameters.buffer_size = 32; %which was used in the openMHA recording
import_parameters.number_smarting_channel = 24; %number of channels from smarting amp
import_parameters.number_audio_channel = 2; % number of audio channels (raw, marker)
%EEGLAB
parameters.lower_cutoff_freq = 0.1;
parameters.higher_cutoff_freq = 10;
parameters.channel_edit_path = '/home/steffen/Documents/eeglab2020_0/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp';
parameters.baseline_removal = true;
parameters.baseline = [-200 0]; % in ms
parameters.timerange = [-0.2 0.8] % Epoch from -200 ms to 800 ms
parameters.marker1 = '1'
parameters.marker2 = '2'
% epoch parameters for ERP Analysis
parameters.epoch_erp.locthresh = 3;
parameters.epoch_erp.globthresh = 3;
parameters.epoch_erp.superpose = 0;
parameters.epoch_erp.reject = 1;
parameters.epoch_erp.vistype = 0;
% epoch parameters for Classification
parameters.epoch_class.locthresh = 3;
parameters.epoch_class.globthresh = 3;
parameters.epoch_class.superpose = 0;
parameters.epoch_class.reject = 0;
parameters.epoch_class.vistype = 0;
end
