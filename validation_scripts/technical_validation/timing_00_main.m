%% Description

% This script contains all processing steps involved in the technical
% validation of the setup.

%% Clear everything
clc
clear 
close all

%% Add own functions and EEGLAB
addpath('./../../functions/')
% addpath to your own EEGLAB path (Version used in thesis: 2020.0)
%addpath('.../eeglab2020_0')
addpath('/home/steffen/Documents/eeglab2020_0')

%% Script

% import data
timing_01_import();
% interpolate and epoch
timing_02_interpolate_epoch()
% baseline correction
timing_03_baseline_removal()
% plot all
timing_04_plot_all()
%compute parameters
timing_05_compute_table()