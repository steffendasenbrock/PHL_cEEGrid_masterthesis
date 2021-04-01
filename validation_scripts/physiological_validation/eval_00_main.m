%% Description
% This script contains all processing steps involved in the physiological
% validation of the setup.

%% Clear everything
clc
clear 
close all

%% Add own functions and EEGLAB
addpath('./../../functions/')
% % addpath to your own EEGLAB path (Version used in thesis: 2020.0)
%addpath('.../eeglab2020_0')
addpath('/home/steffen/Documents/eeglab2020_0')

%% Script
% Import Raw data from openMHA plugin acrec
eval_01_import()
% Filter EEG data
eval_02_filter()
% Apply ASR to filtered data
eval_03_asr()
% Epoch data
eval_04_epoch()
% Plot ERP
eval_05_plot_erp()
% Calculate N100 latencies
eval_06_erp_calculate_features()
% LDA Classification
eval_07_LDA_classification()
% Plot LDA results
eval_08_LDA_plot()