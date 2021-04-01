function [EEG] = kick_data(EEG,trial_number_threshold)
%% Description
% This function kicks out all epochs exceeding a specific number, i.e.
% only the first n_trial_number_threshold remain

if numel(EEG.event)>trial_number_threshold
   kick_last_events = zeros(1,numel(EEG.event));
   diff = numel(EEG.event)-trial_number_threshold
   kick_last_events(end-diff+1:end) = true;
   EEG = pop_rejepoch(EEG, kick_last_events,0);
end


end