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

%% Sender MHA
mha_set(openmha{1}, 'cmd', 'quit' ); % Quit potentially old config
pause(5); % Wait 5 seconds for new openMHA to get started
mha_query(openmha{1},'',['read:' directory send_script]); % Start new config
mha_set(openmha{1}, 'mha.mhachain.addsndfile.level', '100' ); % Set sound volume

disp('Press Enter to stop');
pause;
mha_set(openmha{1}, 'cmd', 'quit' ); 







