function [EEG] = eval_04_epoch()
%% Description
% This function epochs the data and rejects epochs fulfilling requirements
% defined in "epoch" struct

%% Paths
PATHIN = './eeglab_datasets/asr_cleaned/';
PATHOUT = './eeglab_datasets/epoched/';

%% Script 
poss_marker = ['1'; '2'];
poss_name = {'_freq';'_rare'}

for subject_name=1:1:5 % five subjects
    for run=1:1:2 % 2 runs for each subject
        for marker = 1:1:2; % two different markers

%load basic information about files to be imported
[import_parameters, parameters] = load_import_parameters(subject_name,run);  
% Import EEG
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',[import_parameters.matrix_name '.set'],'filepath',PATHIN);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% Bring all epochs down to same number
if(marker==1)
    upper_trial_limit = 658; 
    else
    upper_trial_limit = 145; 
end
% Epoch
EEG = pop_epoch( EEG, {poss_marker(marker)}, parameters.timerange, 'newname', ['epochs_around_' num2str(marker)], 'epochinfo', 'yes');
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'gui','off'); 
EEG = eeg_checkset( EEG );
% Reduce data to defined number
EEG = kick_data(EEG,upper_trial_limit);
EEG = eeg_checkset( EEG );

% Remove Baseline
EEG = pop_rmbase( EEG, parameters.baseline ,[]);
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'setname','epochs_around_1_baseline','gui','off'); 
% Save data set
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',[import_parameters.matrix_name poss_name{marker} '.set'],'filepath',PATHOUT);
        end
    end
end

end