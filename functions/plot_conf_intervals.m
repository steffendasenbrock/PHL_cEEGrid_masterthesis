function h = plot_conf_intervals(EEG_signal,channel_cluster_1,channel_cluster_2,color_value,plot_color)

%% Desciption
% This function plot the mean ERP response together with its 95% confidence
% interval

%% Variables
% EEG_signal: Struct from EEGLAB which corresponds to the epoched Data set
% around a stimulus
% channel_cluster_1/2: Channel clusters from which the mean is calculated
% for each cluster and then the difference between both clusters is
% calculated
% color_value: color of confidence interval
% plot_color: color of mean graph

%% Code

% calculate mean difference between cluster channels, mean_channel_diff is
% the mean diff values over all trials
EEG = EEG_signal.data(:,:,:);

[channel_diff, mean_channel_diff] = calculate_channel_cluster_diff(channel_cluster_1,channel_cluster_2,EEG);

time = EEG_signal.times; % time vector
N = size(EEG,3); % for calculation of degrees of freedom
SEM = (std(squeeze(channel_diff)')/sqrt(N)); % calculate SEM
CI95 = tinv([0.025 0.975], N-1); % calculate 95% probability intervals of t-distribution
yCI95 = bsxfun(@times, SEM, CI95(:));  % calculate 95% confidence intervals Of all experiments at each value of time
confidence = yCI95+mean_channel_diff;

h(1) = plot(time, confidence(1,:),'Color',color_value);
hold on
h(2) = plot(time, confidence(2,:),'Color',color_value); 
hold on
patch([time fliplr(time)], [confidence(1,:) fliplr(confidence(2,:))], color_value,'EdgeColor',color_value);
alpha(0.3);                % set all patches transparency to 0.3
ylim([-4.4 7.8])
xlim([-200 800])
hold on
h(3) = plot(time,mean_channel_diff,'LineWidth', 1,'Color',plot_color);
hold on

end

