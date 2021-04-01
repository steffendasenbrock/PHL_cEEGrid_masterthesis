%% Import Paths 
clear java
% These paths might differ, depending on your operating system (linux used
% here)
% for more details see openMHA starting guide:
% http://www.openmha.org/docs/openMHA_starting_guide.pdf
setenv('LD_LIBRARY_PATH','')
addpath('/usr/lib/openmha/mfiles')
javaaddpath('/usr/lib/openmha/mfiles/mhactl_java.jar')

%% Set Parameters
[openmha, directory] = setup_openmha_connections();
send_script = 'play_oddball_stereo.cfg';
measurement_time = 900; % in seconds
level_dB = 100;

%% Add functions/paths
addpath('./../../Functions/xdf-Matlab')
addpath('./../../Functions/')

%% Clear up both MHAs

system(['ssh mha@10.0.0.1 ' '"mha --port=' num2str(openmha{2}.port) ' --interface="0.0.0.0" " &']);
pause(1);
mha_set(openmha{2}, 'cmd', 'quit' );
mha_set(openmha{1}, 'cmd', 'quit' );
pause(1);

%% Choose Subject Number
prompt = 'Type in Subject Number \n';
subject_number = input(prompt);
[answer_subject, new_subject,new_subject_number] = create_folder_phl(subject_number,directory);    

disp('Press Enter to start receiver openMHA');
pause;

system(['ssh mha@10.0.0.1 ' '"mha --port=' num2str(openmha{2}.port) ' --interface="0.0.0.0" " &']);

disp('Press Enter to read in openMHA configuration');
pause;

%% Basic Settings
mha_set(openmha{2}, 'nchannels_in', '2');
mha_set(openmha{2}, 'srate', '8000');
mha_set(openmha{2}, 'fragsize', '32');
mha_set(openmha{2}, 'mhalib', 'mhachain');

%% Define plugin chain
mha_set(openmha{2}, 'mha.algos', '[lsl2ac acrec:openMHA_time_series acrec:openMHA_time_stamps acrec:openMHA_clock_corrections acrec:smarting_time_series acrec:smarting_time_stamps acrec:smarting_clock_corrections]');

%% lsl2ac
mha_set(openmha{2}, 'mha.lsl2ac.streams', '[openMHA Android_EEG_010016]');
mha_set(openmha{2}, 'mha.lsl2ac.underrun_behavior', 'zero');
mha_set(openmha{2}, 'mha.lsl2ac.overrun_behavior', 'ignore');

%% openMHA time series
mha_set(openmha{2}, 'mha.openMHA_time_series.varname', 'openMHA');
mha_set(openmha{2}, 'mha.openMHA_time_series.prefix', [directory 'subject_no_' num2str(new_subject_number) '/openMHA_time_series']);
mha_set(openmha{2}, 'mha.openMHA_time_series.record', 'yes');

%% openMHA time stamps
mha_set(openmha{2}, 'mha.openMHA_time_stamps.varname', 'openMHA_ts');
mha_set(openmha{2}, 'mha.openMHA_time_stamps.prefix', [directory 'subject_no_' num2str(new_subject_number) '/openMHA_time_stamps']);
mha_set(openmha{2}, 'mha.openMHA_time_stamps.record', 'yes');

%% openMHA clock corrections
mha_set(openmha{2}, 'mha.openMHA_clock_corrections.varname', 'openMHA_tc');
mha_set(openmha{2}, 'mha.openMHA_clock_corrections.prefix', [directory 'subject_no_' num2str(new_subject_number) '/openMHA_clock_corrections']);
mha_set(openmha{2}, 'mha.openMHA_clock_corrections.record', 'yes');

%% smarting time series
mha_set(openmha{2}, 'mha.smarting_time_series.varname', 'Android_EEG_010016');
mha_set(openmha{2}, 'mha.smarting_time_series.prefix', [directory 'subject_no_' num2str(new_subject_number) '/smarting_time_series']);
mha_set(openmha{2}, 'mha.smarting_time_series.record', 'yes');

%% smarting time stamps
mha_set(openmha{2}, 'mha.smarting_time_stamps.varname', 'Android_EEG_010016_ts');
mha_set(openmha{2}, 'mha.smarting_time_stamps.prefix', [directory 'subject_no_' num2str(new_subject_number) '/smarting_time_stamps']);
mha_set(openmha{2}, 'mha.smarting_time_stamps.record', 'yes');

%% smarting clock corrections
mha_set(openmha{2}, 'mha.smarting_clock_corrections.varname', 'Android_EEG_010016_tc');
mha_set(openmha{2}, 'mha.smarting_clock_corrections.prefix', [directory 'subject_no_' num2str(new_subject_number) '/smarting_clock_corrections']);
mha_set(openmha{2}, 'mha.smarting_clock_corrections.record', 'yes');

%% IOLIB
mha_set(openmha{2}, 'iolib', 'MHAIOJackdb');
mha_set(openmha{2}, 'io.name', 'MHA2');
mha_set(openmha{2}, 'io.con_out', '[system:playback_1]');

disp('Press Enter to start openMHA configuration');
pause;

%% Sender MHA
mha_set(openmha{1}, 'cmd', 'quit' ); % Quit potentially old config
pause(5); % Wait 5 seconds for new openMHA to get started
mha_query(openmha{1},'',['read:' directory send_script]); % Start new config
mha_set(openmha{1}, 'mha.mhachain.addsndfile.level', num2str(level_dB) ); % Set sound volume
pause(5)
mha_set(openmha{2}, 'cmd', 'start' );
disp('Started');
pause(measurement_time)
% disp('Press Enter to stop recording');
% pause;
% disp('Are you really sure to stop recording? If yes, press enter');
% pause;
mha_set(openmha{2}, 'cmd', 'quit' );
pause(5)
mha_set(openmha{1}, 'cmd', 'quit' );