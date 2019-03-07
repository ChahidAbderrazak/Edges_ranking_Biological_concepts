
close all
global cnt

clearvars lgnd Results_Comp Data_indexed_Blcd Outcome
% TS_Data_indexed_GR.ABab2=TS_Data_indexed_GR.ABFreq./(TS_Data_indexed_GR.AProb+TS_Data_indexed_GR.BProb);
% TS_Data_indexed_GR.ABab3=TS_Data_indexed_GR.ABFreq.*(TS_Data_indexed_GR.AProb+TS_Data_indexed_GR.BProb);
% TS_Data_indexed_GR.ABab4=TS_Data_indexed_GR.ABFreq.*(TS_Data_indexed_GR.AProb.*TS_Data_indexed_GR.BProb);
% TS_Data_indexed_GR.ABab5=TS_Data_indexed_GR.ABFreq./(TS_Data_indexed_GR.AProb.*TS_Data_indexed_GR.BProb);


%% Split the groun truth grapg to Training and test
TS_Ratio=20;        % the percentage of testing data with respect to the groung truth
Data_indexed_Blcd=TS_Data_indexed_GR;%(:,[1:11 14]);

% [Data_indexed_GR_Blcd]=Get_balanced_Testing_data(TS_Ratio,TS_Data_indexed_GR);
% Data_indexed_Blcd=Data_indexed_GR_Blcd;%(:,[1:11 14]);

%% Sort the classes from top 1 to 0
Data_indexed_Blcd_TS=sortrows(Data_indexed_Blcd ,'Class','descend');


%% ###############         Comparison           #########################

close all


A=Data_indexed_Blcd_TS.AFreq;
B=Data_indexed_Blcd_TS.BFreq;
F=Data_indexed_Blcd_TS.ABFreq;
FDR=Data_indexed_Blcd_TS.FDR;
Pvalue=Data_indexed_Blcd_TS.Pvalue;
ABab=Data_indexed_Blcd_TS.ABab;
ABCFreq=Data_indexed_Blcd_TS.ABCFreq;

Min=min(A,B);
Max=max(A,B);
Coef=Min./Max;

class=Data_indexed_Blcd_TS.Class;
Np=max(size(class==1));
Nn=max(size(class==0));
cnt=1;
figure(12);
plot( normalize(class,'range'), 'r', 'LineWidth',3);hold on
lgnd{cnt}='Ranked data';cnt=cnt+1;

fprintf('\n--------- Edges Ranking %d-------------- \n    \n-------------------------------------\n',Np)

%% ABFreq SCore
[Results_prediction,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,F) ;           
Results_Comp=Data_indexed_Blcd_TS(:,{'EdgeNumber', 'concept_a','concept_b','AFreq','BFreq','Class'});
Results_Comp.ABRatio=A./B;

Results_Comp.ABFreq=Results_prediction.Score;Results_Comp.ClssABFreq=Results_prediction.Predicted;  
Outcome(cnt,:)=[mAP accuracy Top1]  ;

fprintf(' ABFreq= %.2f,  Top%d  mAP=%f , [%.5e] \n-------------------------------------\n',accuracy,Top1,mAP,Over_Under_rank)
lgnd{cnt}='ABFreq';cnt=cnt+1;



%% FDR SCore
[Res_FDR,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,FDR) ;           

Results_Comp.Sc_FDR=Res_FDR.Score;Results_Comp.FDR=Res_FDR.Predicted;  
Outcome(cnt,:)=[mAP accuracy Top1]  ;
fprintf(' FDR= %.2f,  Top%d  mAP=%f , [%.5e] \n-------------------------------------\n',accuracy,Top1,mAP,Over_Under_rank)
lgnd{cnt}='FDR';cnt=cnt+1;



%% ABab SCore
 
[Res_ABab,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,ABab) ;           

Results_Comp.ABab=Res_ABab.Score;Results_Comp.ClssABab=Res_ABab.Predicted;  
Outcome(cnt,:)=[mAP accuracy Top1]  ;
fprintf(' ABab= %.2f,  Top%d  mAP=%f , [%.5e] \n-------------------------------------\n',accuracy,Top1,mAP,Over_Under_rank)
lgnd{cnt}='ABab=F*A*B';cnt=cnt+1;


%% PMI SCore
PMI=log(F./(A.*B));
[Res_PMI,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,PMI) ;           

Results_Comp.PMI=Res_PMI.Score;Results_Comp.ClssPMI=Res_PMI.Predicted;  
Outcome(cnt,:)=[mAP accuracy Top1]  ;
fprintf(' PMI= %.2f,  Top%d  mAP=%f , [%.5e] \n-------------------------------------\n',accuracy,Top1,mAP,Over_Under_rank)
lgnd{cnt}='PMI=log(F./(A.*B))';cnt=cnt+1;

%% PMI SCore
Cap=F./(log(A)+log(B));%log(F./(A+B));
[Res_Cap,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,Cap) ;           

Results_Comp.Cap=Res_Cap.Score;Results_Comp.ClssCap=Res_Cap.Predicted;  
Outcome(cnt,:)=[mAP accuracy Top1]  ;
fprintf(' Capacity= %.2f,  Top%d  mAP=%f , [%.5e] \n-------------------------------------\n',accuracy,Top1,mAP,Over_Under_rank)
lgnd{cnt}='Capacity= F./(log(A)+log(B))';cnt=cnt+1;



%% Pvalue SCore
[Res_Pvalue,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,ABCFreq) ;           

Results_Comp.Pvalue=Res_Pvalue.Score;Results_Comp.ClssPvalue =Res_Pvalue.Predicted;  
Outcome(cnt,:)=[mAP accuracy Top1]  ;
fprintf(' ABCFreq= %.2f,  Top%d  mAP=%f , [%.5e] \n-------------------------------------\n',accuracy,Top1,mAP,Over_Under_rank)
lgnd{cnt}='ABCFreq=1/(Pa + Pb)';cnt=cnt+1;


%% Pvalue SCore
[Res_Pvalue,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,Pvalue) ;           

Results_Comp.Pvalue=Res_Pvalue.Score;Results_Comp.ClssPvalue =Res_Pvalue.Predicted;  
Outcome(cnt,:)=[mAP accuracy Top1]  ;
fprintf(' P_value= %.2f,  Top%d  mAP=%f , [%.5e] \n-------------------------------------\n',accuracy,Top1,mAP,Over_Under_rank)
lgnd{cnt}='P_{Value}';cnt=cnt+1;


% Results_Comp = sortrows(Results_Comp,'Pvalue','descend');
% Results_Comp = sortrows(Results_Comp,'Cap','descend');
% Results_Comp = sortrows(Results_Comp,'PMI','descend');
% Results_Comp = sortrows(Results_Comp,'ABab','descend');
% Results_Comp = sortrows(Results_Comp,'ABFreq','descend');


Feature=Results_Comp(:, {'ClssABFreq', 'ClssABab','ClssPMI','ClssCap','ClssPvalue','Class'});

% %% FAB : F*A*B
% Data_indexed_Blcd_TS.FAB=F.*A.*B;
% 
% [FAB,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,Data_indexed_Blcd_TS.FAB) ;           
% 
% Results_Comp.FAB=FAB.Score;Results_Comp.ClssFAB=FAB.Predicted;  
% Outcome(cnt,:)=[mAP accuracy Top1]  ;
% fprintf(' F*A*B* = %.2f,  Top%d  mAP=%f , [%.5e] \n-------------------------------------\n',accuracy,Top1,mAP,Over_Under_rank)
% lgnd{cnt}='F*A*B';cnt=cnt+1;

% 
% %% Learn from wrong ab_frequ
% Wrong_abFreq=Results_Comp(60:200,{'EdgeNumber','AFreq','BFreq','ABFreq', });
% a=Wrong_abFreq.AFreq;
% b=Wrong_abFreq.BFreq;
% f=Wrong_abFreq.ABFreq;
% 
% Wrong_abFreq.Score10=abs(b-a)./f;%./max(b,a);

% %% Assign new score
% 
% Data_indexed_Blcd_TS.absFoverF=abs(B-A)./F;%./max(b,a);;
% 
% 
% [absFoverF,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,Data_indexed_Blcd_TS.absFoverF) ;           
% 
% Results_Comp.ScoreabsFoverF=absFoverF.Score;Results_Comp.absFoverF=absFoverF.Predicted;  
% Outcome(cnt,:)=[mAP accuracy Top1]  ;
% fprintf('|(A,B)|/f)= %.2f,  Top%d  mAP=%f , [%.5e] \n-------------------------------------\n',accuracy,Top1,mAP,Over_Under_rank)
% lgnd{cnt}=' |(A,B)|/f';cnt=cnt+1;


%%  #########################  SVD   #########################
Outcome_old=Outcome;
Results_Comp.Class3=Data_indexed_Blcd_TS.Class;



% % %% Score the graph KSVD with threshold level
% Level=1.5;
% [ ScoreL,Ranked_Adge_L, KSVD_L]=SVD_Levels_based_ranking(Level, Sparse_Data, Data_indexed_Blcd);
% 
% 
% [Results_prediction,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,ScoreL) ;           
% Results_Comp.ScoreL=Results_prediction.Score;  Results_Comp.SVDL=Results_prediction.Predicted;  
% Outcome(cnt,:)=[mAP accuracy Top1]  ;
% fprintf(' SVDL= %.2f,  Top%d [%.5e] K=%.2f \n-------------------------------------\n',accuracy,Top1,Over_Under_rank,KSVD_L)
% lgnd{cnt}='SVD_{L}';cnt=cnt+1;
% 
% 
% %% Score the only eges in the groundtruth using  KSVD
% [ ScoreGR,Ranked_Adge_GR, KSVD_GR]=SVD_based_ranking(TS_Sparse_Data, Data_indexed_Blcd);
% 
% [Results_prediction,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,ScoreGR) ;           
% Results_Comp.ScoreGR=Results_prediction.Score;  Results_Comp.SVDGR=Results_prediction.Predicted;  
% Outcome(cnt,:)=[mAP accuracy Top1]  ;
% fprintf(' SVDGR= %.2f,  Top%d [%.5e] K=%.2f \n-------------------------------------\n',accuracy,Top1,Over_Under_rank,KSVD_GR )
% lgnd{cnt}='SVD_{GR}';cnt=cnt+1;
% 
% 
% 
% A=legend(lgnd);
% A.FontSize=14;
% 
% %% Table  of the results
% filename='Result_ABFreq';
% Name_Scores=lgnd(2:end)';
% % Outcome_Table=array2table(Name_Scores,'VariableNames',{'ScoreName'});
% % Outcome_Table.accuracy=Outcome(2:end,1);
% % Outcome_Table.OverRankingIndex=Outcome(2:end,2);
% % 
% % save(strcat(filename,'.mat'),'Results_Comp','Outcome_Table')
% 
% % %% EXCEL
% % writetable(Results_Comp,strcat(filename,'.xlsx'))
% 
Results_Comp2=Results_Comp;Results_Comp1=Results_Comp;
% % Edges=unique([Results_Comp1.EdgeNumber(1:25); Results_Comp2.EdgeNumber(1:26)])