function [ACC, X, Y, T, AUC, scores] = eval_07_LDA_cross_session(models,marker_one, marker_two, SUBJECT)
%% Description
% This function computes the scores of the second session
% when using a classifier trained on the first session
% Also compute corresponding AUC

PATHIN = './eeglab_datasets/asr_cleaned/';
SESSIONS = {'_run_1', '_run_2'};
% Set names
fname_session2 = ['subject_no_' num2str(SUBJECT) SESSIONS{2} '.set'];
fname_session2_path = [PATHIN];
%Create test table consisting of all epochs of session 2     
[cross_session_test_table]  = sab_create_table(fname_session2, fname_session2_path, marker_one, marker_two,SUBJECT,'2');
TEST_TABLES = cross_session_test_table;
% compute scores and labels, scores is predicted label, when theshold of
% 0.5 is used.
% Model of session 1 is used to compute scores of session 2
[label, scores] = models{1}.classifier.predictFcn(TEST_TABLES);
% compute accuracy and so on parameters (not used in thesis)
[CM, GORDER] = confusionmat(TEST_TABLES.Label, label);
tp = CM(1,1);
fn = CM(1,2);
fp = CM(2,1);
tn = CM(2,2);
% https://classeval.wordpress.com/introduction/basic-evaluation-measures/
acc = (tp+tn)/(tp + tn + fn + fp);
ACC = acc;      
% score contains the posterior prob that a given datapoint belongs to the class  
% Receiver Operator Characteristic
%Set odd class as positive
pos_class_name = marker_two;
[X,Y,T,AUC,OPTROCPT]  = perfcurve(TEST_TABLES.Label, scores(:,2), pos_class_name);
    
end