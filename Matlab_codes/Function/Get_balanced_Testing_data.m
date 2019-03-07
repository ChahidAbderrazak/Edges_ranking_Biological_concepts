function [Data_indexed_GR_Blcd, X_train_k, X_test_GR_k, X_train_GR_k, X_test_k]=Get_balanced_Testing_data(TS_Ratio,Data_indexed_GR)

fprintf('\n--> Set Balanced dataset for the cross validation.\n')


C1=Data_indexed_GR.Class;
Data_indexed_GR = shuffleRow(Data_indexed_GR);
C2=Data_indexed_GR.Class;


%%% All 
%%  Get the balanced ground truth with the features : abFreq, fdr...
Ind0=find(Data_indexed_GR.Class==0);Ind1=find(Data_indexed_GR.Class==1);
N_TS=min(size(Ind1),size(Ind0));
Data_indexed_GR_Blcd=[Data_indexed_GR(Ind1(1:N_TS),:);Data_indexed_GR(Ind0(1:N_TS),:)];

%% Split data to the training and testing 
N=size(Data_indexed_GR,1);
TR=floor(0.01*TS_Ratio*N/2);%TR=floor(0.2*N_TS);
    %  for All the features : abFreq, fdr...
    X_test_k=[Data_indexed_GR(Ind1(1:TR),:);Data_indexed_GR(Ind0(1:TR),:);];
    X_train_k=[Data_indexed_GR(Ind1(TR+1:end),:);Data_indexed_GR(Ind0(TR+1:end),:);];

    %% for concepts and class
    Data_indexed_Blcd=Data_indexed_GR_Blcd(:,{'NodeA','NodeB','Class'});
    X_test_GR_k= X_test_k(:,{'NodeA','NodeB','Class'});
    X_train_GR_k= X_train_k(:,{'NodeA','NodeB','Class'});

    
Data_indexed_Blcd=sortrows(Data_indexed_Blcd ,'Class','descend');
Data_indexed_GR_Blcd=sortrows(Data_indexed_GR_Blcd ,'Class','descend');
X_train_k=sortrows(X_train_k ,'Class','descend');
X_test_GR_k=sortrows(X_test_GR_k ,'Class','descend');Data_indexed_Blcd=sortrows(Data_indexed_Blcd ,'Class','descend');
X_train_GR_k=sortrows(X_train_GR_k ,'Class','descend');   
X_test_k=sortrows(X_test_k ,'Class','descend');   

% TR0=IsBalancedSet(X_train_k.Class)
% TS0=IsBalancedSet(X_test_k.Class)


d=1;
% 
% %% USE FOLDS CV 
% Data=table2array(Data_indexed_GR);
% Class=Data(:,end)
% %% Balnced cross validation
% nb_folds=5;
% CVO = cvpartition(Class,'KFold',nb_folds)%,'Stratify',false)
% 
% for k = 1%:nb_folds
% 
%     fprintf('\n----- Fold %d  ----\n',k)
%     trIdx = CVO.training(k);
%     teIdx = CVO.test(k);
% 
%     
%     X_train_k=Data_indexed_GR(trIdx,:);
%     X_test_k =Data_indexed_GR(teIdx,:);
% 
% end
% 
% 
% sum(X_train_k.Class)
% sum(X_test_k.Class)
