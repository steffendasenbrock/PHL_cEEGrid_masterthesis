function [openmha, directory] = setup_openmha_connections()

%% Desciption
% This function contains the parameters host name and port to connect to the openMHA on the PHL

% openMHA ports and host names
openmha{1}.host = '10.0.0.1';
openmha{1}.port = 33337;
openmha{2}.host = '10.0.0.1';
openmha{2}.port = 33338;

% Path directory of configurations
directory = '/home/mha/';

end
