function [MODEL, N_ONE, N_TWO] = eval_crossvalidation(marker_one, marker_two, SUBJECT, run)
%% Description
% This function creates a struct MODEL which contains performance
% metric resultung from a cross validation of the session and a trained
% classifier MODEL.classifier which was trained on all the data of the 
% session, only the MODEL.classifier of each subject's first run are used
% for the cross-session classification

% code was adapted from https://github.com/s4rify/fEEGrid_paper


%% Define Paths to get data from
PATHIN = './eeglab_datasets/epoched/';
SESSIONS = {'_run_1', '_run_2'};    
m = 1;
fname = ['subject_no_' num2str(SUBJECT) SESSIONS{run} '.set'];
session_path = [PATHIN];
% create table containing 50 ms mean features and labels
[cross_valid_table, n_one, n_two]  = sab_create_table(fname, session_path, marker_one, marker_two,SUBJECT,run);
% extract information which is otherwise hardcorded in the generated code of the classification learner app
predictor_names = cross_valid_table.Properties.VariableNames;
class_names = ['1'; '2'];
% create classification model
[classifier, accuracy, validationPredictions, validationScores, kfold_accuracies, kfold_auc, AUC] = ...
 trainClassifier(cross_valid_table, predictor_names, class_names);    
% the trained classifier "classifier" is trained on all data of the session
 % assemble information
MODEL{m}.type = fname(1:end-10);
MODEL{m}.session = SESSIONS{run}(2:end);
MODEL{m}.filename = fname;
MODEL{m}.classifier = classifier;
% these are the performance scores for the validated model
MODEL{m}.acc = accuracy;
MODEL{m}.labels = cross_valid_table.Label;
MODEL{m}.kfold_predictions = validationPredictions;
MODEL{m}.kfold_scores = validationScores;
MODEL{m}.AUC = AUC;
% these perfomances are the ones for every split in the cross validation
MODEL{m}.kfold_accuracies = kfold_accuracies;
MODEL{m}.kfold_auc = kfold_auc;
N_ONE(m) = n_one;
N_TWO(m) = n_two;
    
end


