function raw_dat = import_dat_file(input_file)
%% Description

% This function imports raw data from .dat file recorded by acrec (openMHA)

%% Input Variables

% input_file = input file (of type .dat) to be imported

%% Code

fid = fopen(input_file,'r');
raw_dat = fread(fid,'double');


end

