function [] = eval_03_asr()
%% Description
% This function applies an Artefact Subspace Reconstruction (ASR) to the
% filtered data
%% Paths
PATHIN = './eeglab_datasets/filtered/';
PATHOUT = './eeglab_datasets/asr_cleaned/';

%% Function Code

for subject_name=1:1:5 % five subjects
    for run=1:1:2 % 2 runs for each subject

%load basic information about files to be imported
[import_parameters, parameters] = load_import_parameters(subject_name,run);  
% Import raw dataset 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',[import_parameters.matrix_name '.set'],'filepath',PATHIN);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% save original channel information for interpolation
originalEEG.chanlocs = EEG.chanlocs;
% run ASR 
EEG = clean_rawdata(EEG, 60, [0.25 0.75], 'off', 'off', 20, -1 );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'setname','asr','gui','off'); 
EEG = eeg_checkset( EEG );
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

% delete faulty channels
    
if ~(length({EEG.chanlocs.labels})==0)
   EEG = pop_rejchan(EEG, 'elec',1:EEG.nbchan ,'threshold',3,'norm','on','measure','spec','freqrange',[parameters.lower_cutoff_freq parameters.higher_cutoff_freq]);
end

% store faulty channel information in structure
EEG.remaining_chans = EEG.chanlocs;

% interpolate lost channels (if there are any left)
if ~(length({EEG.chanlocs.labels})==0)
    EEG = pop_interp(EEG,originalEEG.chanlocs, 'spherical');
end
    
% Save data set
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',[import_parameters.matrix_name '.set'],'filepath',PATHOUT);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

    end
end

end