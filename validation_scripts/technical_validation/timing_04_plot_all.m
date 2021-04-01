function [] = timing_06_plot_all()
%% Description
% This function plots the latency of the rising edges as a function of 
%recording time for all measurements
%% Paths

PATHIN = './eeglab_datasets/baseline_corrected/';
PATHOUT = './eeglab_datasets/plots/';

%% Function Code

for measurement_no=1:1:8 % loop through all measurements
    
% load parameters    
[import_parameters, parameters] = load_import_parameters_timing(measurement_no);        
% load dataset    
load([PATHIN '/measurement_' num2str(measurement_no)]);
% plot mean epoch
[~, index] = find(EEG.absolute_point_in_time);

plot(EEG.absolute_point_in_time(index),EEG.time_rising_edges(index)*1000,'linewidth', 1)

set(gca,'fontsize',12,'FontName','Times New Roman') % Sets the width of the axis lines, font size, font
xlabel('Recording time / s','fontsize',15,'interpreter','latex','FontName','Times New Roman')
ylabel('Latency / ms','fontsize',15,'interpreter','latex','FontName','Times New Roman')
xlim([0 900]);
grid on
set(gca,'TickLabelInterpreter','latex')
box on
axis_scales = axis; 
hold on
end

end