function  Plot_ROC(Roc)

figure(123);
plot(Roc(:,1), Roc(:,2), 'LineWidth',2);hold on
A=legend('Ranking threshold variation');
A.FontSize=14;
title('Receiver Operating Characteristic curve (ROC)');
ylabel('True positive rate (Sensitivity) ')
xlabel('False positive rate (1 - Specificity) ')

% xlim([0 1]);
% ylim([0 1])

set(gca,'fontsize',16)


d=1;
