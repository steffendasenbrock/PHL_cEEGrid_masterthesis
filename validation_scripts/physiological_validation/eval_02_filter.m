function [] = eval_02_filter()
%% Description
% This function filters the raw data with a high pass and low pass filter
%% Paths

PATHIN = './eeglab_datasets/raw_data/';
PATHOUT = './eeglab_datasets/filtered/';

%% Function Code

for subject_name=1:1:5 % five subjects
    for run=1:1:2 % 2 runs for each subject

%load basic information about files to be imported
[import_parameters, parameters] = load_import_parameters(subject_name,run);        
% Import raw dataset 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',[import_parameters.matrix_name '.set'],'filepath',PATHIN);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% Low Pass Filter
EEG = pop_eegfiltnew(EEG,[],10,330,0,[],0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname','low_passed','gui','off');
% High Pass filter
EEG = pop_eegfiltnew(EEG, 0.1,[],8250,0,[],0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname','high_passed','gui','off');
% Save data set
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',[import_parameters.matrix_name '.set'],'filepath',PATHOUT);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

    end
end

end