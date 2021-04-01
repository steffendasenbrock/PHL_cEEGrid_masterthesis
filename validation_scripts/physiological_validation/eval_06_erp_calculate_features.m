function eval_06_erp_calculate_features()
%% Description
% This function extracts the N100 latencies

% Extract Epoched from EEGLAB dataset 
for ss=1:1:5
    for rr=1:1:2   

subject_name = num2str(ss);
run = {'_run_1_','_run_2_'}  
%Start EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%Load Frequent Data Set
EEG = pop_loadset('filename',['subject_no_' subject_name run{rr} 'freq.set'],'filepath','/home/steffen/Documents/Uni/phlceegrid/Tasks/T1428_evaluate_pilot_study/eeglab_datasets/epoched/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%Load Rare Data Set
EEG = pop_loadset('filename',['subject_no_' subject_name run{rr} 'rare.set'],'filepath','/home/steffen/Documents/Uni/phlceegrid/Tasks/T1428_evaluate_pilot_study/eeglab_datasets/epoched/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%Extract Epoched EEG Data
freq_eeg{ss,rr} = ALLEEG(end-1);
rare_eeg{ss,rr} = ALLEEG(end);
    end
end

channel_cluster_1 = [2 3];
channel_cluster_2 = [6 7];

%% N100 Extraction
% Where to look for the N100?
t_n100 = 100; % in ms
t_n100_boundary = 50; % in ms

for ss=1:1:5
    for rr=1:1:2   

%% Change to rare if wanted
EEG = freq_eeg{ss,rr}.data;
[channel_diff, mean_channel_diff] = calculate_channel_cluster_diff(channel_cluster_1,channel_cluster_2,EEG);
time_axis = freq_eeg{ss,rr}.times;
index = extract_response_boundary(time_axis,t_n100,t_n100_boundary);
N100_time_line = time_axis(index(1):index(3));
[amplitude , dummy_index] = min(mean_channel_diff(index(1):index(3)));
N100_amplitude{ss,rr} = amplitude;
N100_latency{ss,rr} = N100_time_line(dummy_index)

    end
end
mean_value_n100 = mean(mean(cell2mat(N100_latency)))

end


