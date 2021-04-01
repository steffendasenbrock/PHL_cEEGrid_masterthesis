function [] = eval_01_import()
%% Description
% This function goes though all measurements and imports 
% the LSL streams from the Smarting system and the openMHA sender system
% (recorded with the openMHA acrec plugin) into EEGLAB

%% Function Code

for subject_name=1:1:5 % five subjects
    for run=1:1:2 % 2 runs for each subject

 % Import acrec data
[streams, parameters,import_parameters] = import_acrec_data(subject_name, run);
% calculate effective sampling rates
streams = handle_jitter_removal(streams);
% Import acrec data into EEGLAB
% Start EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% Import Data
%EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',[import_parameters.matrix_path import_parameters.matrix_name '.mat'],'srate',streams{1}.effective_rate,'pnts',0,'xmin',0);
EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',[import_parameters.matrix_path import_parameters.matrix_name '.mat'],'srate',250,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','raw_data','gui','off'); 
EEG = eeg_checkset( EEG );
% Import Marker
EEG = pop_importevent( EEG, 'event',[import_parameters.event_matrix_path '.txt'],'fields',{'number','type','latency','duration'},'timeunit',1);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
% Select only first 8 channels of 24
EEG = pop_select( EEG, 'channel',[1:8] );
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','channel_selection','gui','off'); 
EEG = eeg_checkset( EEG );
% Import electrode position file
EEG=pop_chanedit(EEG, 'lookup',parameters.channel_edit_path,'load',{'./elec_cEEGrid_right_ear.elp','filetype','autodetect'});
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',[import_parameters.matrix_name '.set'],'filepath','./eeglab_datasets/raw_data/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

    end
end


end
