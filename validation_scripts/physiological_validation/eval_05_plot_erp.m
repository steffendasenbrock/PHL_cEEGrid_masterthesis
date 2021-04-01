function eval_05_plot_erp()
%% Description
% This function plots the ERPs along the vertical bipolar channel, i.e.
% (R2+R3)/2-(R6+R6)/2

PATHIN = './eeglab_datasets/epoched/';


% Import extracted Epoched Data
for ss=1:1:5
    for rr=1:1:2   
subject_name = num2str(ss);
run = {'_run_1_','_run_2_'}  
%Start EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%Load Frequent Data Set
EEG = pop_loadset('filename',['subject_no_' subject_name run{rr} 'freq.set'],'filepath',PATHIN);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%Load Rare Data Set
EEG = pop_loadset('filename',['subject_no_' subject_name run{rr} 'rare.set'],'filepath',PATHIN);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%Extract Epoched EEG Data
freq_eeg{ss,rr} = ALLEEG(end-1);
rare_eeg{ss,rr} = ALLEEG(end);
    end
end

% Plot
n = 1;
titles = {'Session 1', 'Session 2'};
for ss=1:1:5
    for rr=1:1:2   
subplot(5,2,n)
channel_cluster_1 = [2 3];
channel_cluster_2 = [6 7];
color_value = [1 0.8 0.8];
plot_color = [1 0 0];
h1 = plot_conf_intervals(rare_eeg{ss,rr},channel_cluster_1,channel_cluster_2,color_value,plot_color);
hold on
color_value = [0.8 0.8 1];
plot_color =  [0 0.4470 0.7410];
h2 = plot_conf_intervals(freq_eeg{ss,rr},channel_cluster_1,channel_cluster_2,color_value,plot_color);
set(gca,'fontsize',20,'FontName','Times New Roman') % Sets the width of the axis lines, font size, font
%xlabel('Latency / ms','fontsize',15,'interpreter','latex','FontName','Times New Roman')
%ylabel('Amplitude / $$\mathrm{\mu} $$V ','fontsize',15,'interpreter','latex','FontName','Times New Roman')
grid on
if n==1 | n==2
    title(titles{n},'fontsize',23,'interpreter','latex','FontName','Times New Roman');
end
legend([h1(3),h2(3)],{'Rare','Freq'},'Location', 'NorthWest','fontsize',15,'interpreter','latex','FontName','Times New Roman');

set(gca,'TickLabelInterpreter','latex')
%xticklabels({'-500',' ',' ',' ', ' ','0',' ',' ', ' ',' ','500',' ',' ',' ',' ', '1000'})
box on
hAx=gca;                    % create an axes
hAx.LineWidth=1.2;            % set the axis linewidth for box/ticks

if(n==9 || n==10)
    xlabel('Latency / ms','fontsize',23,'interpreter','latex','FontName','Times New Roman')
end

n = n+1;
    end
end

position = generate_y_label();
h3=axes('position',position,'visible','off');
h_label=ylabel('Amplitude / $$\mathrm{\mu} $$V ','fontsize',23,'interpreter','latex','FontName','Times New Roman','visible','on')


end


