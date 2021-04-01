function [TABLE, n_one, n_two] = sab_create_table(fname, pathin, marker_one, marker_two,subject_name,run)
%% Description
% This function creates the feature table used to train the classifier
% It consits of 50 ms mean values of the epochs and the corresponding
% label

% adapted from https://github.com/s4rify/fEEGrid_paper

PATHIN = './eeglab_datasets/epoched/';

% Load import parameters    
[import_parameters, parameters] = load_import_parameters(subject_name,run);  
% Define window length to cut epochs
win_len = 12; %25 samples = 100ms (fs = 250 Hz)
% Load EEG data    
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',[import_parameters.matrix_name '_freq' '.set'],'filepath',PATHIN);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG_one = EEG; % frequent EEG
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',[import_parameters.matrix_name '_rare' '.set'],'filepath',PATHIN);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG_two = EEG; % rare EEG

% store size of data sets for this subj
n_one = size(EEG_one.data,3);
n_two = size(EEG_two.data,3);
    
table_one = sab_feature_extraction(EEG_one.data, marker_one, win_len);
table_two = sab_feature_extraction(EEG_two.data, marker_two, win_len);
TABLE = [table_one; table_two];    
end


% helper function which extracts the features: atm this is mean of successive time windows in the epoched
% data for every channel which are stored in a table. the table will have every channel and every
% time window as separate features
% the dimension will be
%
%   -----> n_channels * n_windows
%  |
%  |
%  v
%   n_epoch
%
% Consequently, the label vector will have length n_channels * n_windows and will contain every
% combination of channel and window number
function [tt] = sab_feature_extraction(data, label, win_len)
    winsize  = win_len; %25; % 25 samples = 50ms , 12.5 samples = 25 ms
    len_epoch = size(data,2);
    start_lat = 1;
    %windows = [start_lat : winsize : len_epoch+winsize];
    windows = [start_lat : winsize : len_epoch];
    %n_win = length(windows) -2;
    n_win = length(windows) -1;
    
    % compute the successive window means
    for i = 1 : n_win%-1
        current_window = windows(i) : windows(i+1);
        %current_window = windows(i) : windows(i+1)-1;
        % successive mean will contain channel x #epoch entries, each of which contains
        % the averaged data points of the current time window
        % the result has dimensions n_channels x n_windows x n_epochs
        successive_window_mean(:,i,:) = squeeze(mean(data(:,current_window, :),2));
        
        % each channel is supposed to be one feature in our classification
        % channel 1, all windows, all epochs: successive_win_mean(1,:,:)
        F = successive_window_mean;
    end
    
    % create table
    %   -----> n_channels * n_windows
    %  |
    %  |
    %  v
    %   n_epoch
    n_chan = size(data,1);
    n_epoch = size(data,3);
    n = 1;
    for ch = 1: n_chan
        for w = 1 : n_win
            % whithout loop: reshape(F, [n_win, n_epoch*chans]), but then
            % we loose the information for the VariableName (column name in table),
            % TODO can this be done more elegantly?
            current_col(:,w) = squeeze(reshape(F(ch,w,:), [1, (n_epoch * 1)]))';
            col_name{n} = ['ch', num2str(ch), 'w', num2str(w)];
            % never reset n, because we need to store all combinations of channels and windows here
            n = n + 1;
        end
        % save the current column which contains n_channel x n_windows columns and n_epochs rows
        COLS{ch} = current_col;
    end
    
    % construct the table
    tt = array2table(cell2mat(COLS));
    tt.Properties.VariableNames = col_name;
    labels = repmat(label, n_epoch,1);
    tt.Label = labels;
    
end

