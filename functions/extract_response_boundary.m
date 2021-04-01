function index = extract_response_boundary(time_axis,t,t_boundary)
%% Description
% This function extracts the boundaries to find response
[~, index(1)] = min(abs(time_axis-(t-t_boundary)))
[~, index(2)] = min(abs(time_axis-(t)))
[~, index(3)] = min(abs(time_axis-(t+t_boundary)))

end