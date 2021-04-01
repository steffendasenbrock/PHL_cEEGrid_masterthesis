function [] = print_matrix_to_file(matrix, name, type)
%% Description

% This function is used to output the matrix containing the information
% about the stimuli to be imported into EEGLAB

% This code was copied from
% https://de.mathworks.com/matlabcentral/answers/422602-how-to-write-matrix-to-txt-or-excel-file-with-specific-precision

%% Input Variables

% matrix to be printed to a e.g txt file

%% Code
%% Print event matrix to txt file
M = matrix;
fmt = repmat(',%2.20f',1,size(M,2));
fmt = [fmt(2:end),'\n'];
[fid,msg] = fopen([name '.' type], 'wt');
assert(fid>=3,msg)
fprintf(fid,fmt,M.');
fclose(fid);

end