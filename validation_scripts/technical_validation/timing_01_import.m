function [output_EEG] = timing_01_import()
%% Description
% This function goes though all measurements and imports 
% the LSL streams from the Smarting system and the openMHA sender system
% (recorded with the openMHA acrec plugin) into EEGLAB

%% Function Code

for measurement_no=1:1:8 % loop through all measurements

 % Import acrec data
[streams, parameters,import_parameters] = import_acrec_data_timing(measurement_no);
% calculate effective sampling rates (jitter removal is not applyied in the
% end)
streams_dummy = handle_jitter_removal(streams);
% Import acrec data into EEGLAB
% Start EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% Import Data
EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',[import_parameters.matrix_path import_parameters.matrix_name '.mat'],'srate',streams_dummy{1}.effective_rate,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','raw_data','gui','off'); 
EEG = eeg_checkset( EEG );
% Import Marker
EEG = pop_importevent( EEG, 'event',[import_parameters.event_matrix_path '.txt'],'fields',{'number','type','latency','duration'},'timeunit',1);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
% Select only first 8 channels of 24
EEG = pop_select( EEG, 'channel',[1:8] );
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',[import_parameters.matrix_name '.set'],'filepath','./eeglab_datasets/raw_data/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

output_EEG{measurement_no} = EEG;
end


end