function eval_07_LDA_classification()
%% Description 
% This function:
% - computes AUC scores of a 10-fold cross validation for each session
% and subject
% - uses a model trained on the first session and applies it to the data
% from the second session -> calculates AUC
% stores both

PATHOUT = './eeglab_datasets/class_results/';
%% Cross Validation within session
for ss=1:1:5
    for rr=1:1:2 
[audio_model{ss,rr}] = eval_crossvalidation('1', '2',ss,rr);
    end
end
%% Cross session
for i=1:1:5
[cross_sess{i}.ACC, cross_sess{i}.X, cross_sess{i}.Y, cross_sess{i}.T, cross_sess{i}.AUC, cross_sess{i}.scores] = eval_07_LDA_cross_session(audio_model{i,1},'1', '2',i);
end

% Store data
save([PATHOUT '/cross_validation'],'audio_model')
save([PATHOUT '/cross_session'],'cross_sess')