function eval_08_LDA_plot()
%% Description
% This function is used to plots the AUC of each subject in all
% three classification scenarios (cross-validation-session1, cross-
% validation-session-2 and cross-session)

% load results obtained from classification
load('./eeglab_datasets/class_results/cross_validation.mat')
load('./eeglab_datasets/class_results/cross_session.mat')

% Calculate Standard Error (SE) and AUC for cross validation session 1+2
for ss = 1:1:5
    for rr = 1:1:2
SE(ss,rr) = std(audio_model{ss,rr}{1,1}.kfold_auc)/sqrt(length(audio_model{ss,rr}{1,1}.kfold_auc))
AUC(ss,rr) = mean(audio_model{ss,rr}{1,1}.kfold_auc)
    end
    cross_session_AUC(ss) = cross_sess{ss}.AUC;
end

%% Plots
figure
fontsize_pic = 27;
%% AUC Plot
subplot(1,3,1)
AUC_bar_plot_session_1 = barwitherr(SE(:,1), AUC(:,1));
ylim([0,1]);
ylabel('AUC','fontsize',fontsize_pic,'interpreter','latex','FontName','Times New Roman')
title({'Session 1', ['avg=' num2str(round(mean(AUC(:,1)),2))]},'fontsize',fontsize_pic,'interpreter','latex','FontName','Times New Roman');
grid on
set(gca,'TickLabelInterpreter','latex','FontName','Time New Roman')

set(gca,'FontSize',fontsize_pic)

subplot(1,3,2)
AUC_bar_plot_session_2 = barwitherr(SE(:,2), AUC(:,2));
ylim([0,1]);
title({'Session 2', ['avg=' num2str(round(mean(AUC(:,2)),2))]},'fontsize',fontsize_pic,'interpreter','latex','FontName','Times New Roman');
xlabel('Subject','fontsize',fontsize_pic,'interpreter','latex','FontName','Times New Roman')
grid on
set(gca,'TickLabelInterpreter','latex','FontName','Time New Roman')
set(gca,'FontSize',fontsize_pic)

subplot(1,3,3)
AUC_bar_plot_session_2 = bar(cross_session_AUC);
ylim([0,1]);
title({'Cross-Session', ['avg=' num2str(round(mean(cross_session_AUC),2))]},'fontsize',fontsize_pic,'interpreter','latex','FontName','Times New Roman');
grid on
set(gca,'TickLabelInterpreter','latex','FontName','Time New Roman')
set(gca,'FontSize',fontsize_pic)
set(gcf,'Position',[0 0 500 250])




end
