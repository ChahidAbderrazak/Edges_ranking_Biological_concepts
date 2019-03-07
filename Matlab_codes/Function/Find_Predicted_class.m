%% Find the best thresults for ranking 

function [ Results_prediction,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class, Score)
%% Assign the predicted classes
predict_Class=assign_Class_to_predicted(class, Score);
Results_prediction=[class, predict_Class, Score];
Results_prediction=array2table(Results_prediction,'VariableNames',{'Class','Predicted','Score'});


%% Measure ranking peformance
% %  Compute mAP
    mAP=Compute_mAP(class, predict_Class);
% 
% 
% %  Compute ORI
    Over_Under_rank=ORI_Accuracy(class, predict_Class);
    [MSE,Over_Under_rank0,ORI,Top1, SumTop1]=Ranking_performance(Results_prediction);
    [accuracy, sensitivity, specificity, precision, gmean, f1score]=prediction_performance(class, predict_Class);

% %  Compute ORI_ranks
% ORI_ranks=Get_ranks_of_binary_sequence(class, predict_Class)
ORI_ranks=-1;
%% For testing . it needs to be commented for real running
% 
% Over_Under_rank=ORI_Accuracy(predict_Class,class);
% mAP=Compute_mAP(predict_Class,class);
% d=1;


function  mAP=Compute_mAP(class, predict_Class)
%% mAP is Average Precision across multiple queries/rankings
mAP=0;
Np=max(size(find(class==1)));   
Err=class-predict_Class;

Idx=find(Err==0);
N1=max(size(class));

Err_retrv=Err(1:Np)==0;
TP= size(find(Err_retrv==1),1);
FP= size(find(Err_retrv==0),1);

Err_unretrv=Err(Np+1:end)==0;
FN= size(find(Err_unretrv==1),1);
TN= size(find(Err_unretrv==0),1);

% TrueHightRanks=find(Err_retrv==1);
TrueHightRanks_all=find(predict_Class==1); TrueHightRanks=TrueHightRanks_all;

if size(TrueHightRanks,1)==0
    
    mAP=0;                %% worst ranking
    
else
    cnt=0;
    for k=TrueHightRanks'
        
        cnt=cnt+1;

        mAP=mAP+cnt/k;     %%  add computed  Precision@k
            


    end
    
    mAP=mAP/cnt;
end


d=1;
function predict_Class=assign_Class_to_predicted(class, Score)
N=size(Score,1);ranks=[1:N]';
Class0=zeros(N,1);
Class=Class0;
Np=max(size(find(class==1)));
Class(1:Np)=1;



        Ranked_Edges0=array2table([ranks, class, Score],'VariableNames',{'Position','Class', 'Score'}); 
        
        Ranked_Edges=sortrows(Ranked_Edges0 ,3,'descend');
        Ranked_Edges.Predict_Class=Class;
        
        Ranked_Edges0.Predict_Class=Class0;
        
        for k=1:size(Ranked_Edges0,1)
            Idx=Ranked_Edges.Position(k);
            Ranked_Edges0.Predict_Class(Idx)=Ranked_Edges.Predict_Class(k);
        end
        
        predict_Class=Ranked_Edges0.Predict_Class;
        d=1;

        
function [MSE,Over_Under_rank,ORI,Top1,SumTop1 ]=Ranking_performance(Ranking_example)

global cnt

N=size(Ranking_example,1);
Ranking_example0=sortrows(Ranking_example,'Score','descend');
class=Ranking_example0.Class;
base_class=max(size(unique(class)));
RankL=max(size(find(class==0)));   
RankH=max(size(find(class==1))); 



%% 

max_ORIV=bi2de(fliplr(Ranking_example.Class(1:RankH)'));%max_ORIV=bi2de(fliplr(Ranking_example.Class'));

max_class=2*bi2de(fliplr(Ranking_example.Predicted'));
% opt_class=bi2de(fliplr(predict_Class'));


ORI=max_ORIV;%exp(/(2^(N-1)));%log()/log(2);%(Under_rank-Over_rank);

%% Compute performancce 
Ranking_example=sortrows(Ranking_example,'Score','descend');
class=Ranking_example.Class;
Score=Ranking_example.Class;
predict_Class=Ranking_example.Predicted;
N=size(Score,1);


%% The number of truly preictde label regardless of the ranking
Top1=min(find(class==0))-1;
SumTop1=sum(class(1:RankH));
% Compute the ranking performance 
Rank_weight=class*10 -5;
idx_0=max(size(find(predict_Class==0)));   
idx_1=max(size(find(predict_Class==1))); 
Unblc=RankH-idx_1;



% %% Ranking performance 
%  Flase_ranking=bi2de((1)');
% 
%  

% Performance 
Err=class-predict_Class;

%% Mean square error 
MSE=norm(Err);

%% over ranking the Class0
BiClass0=double(Err==-1 )';
Over_rank=[base_class.^[(N-1):-1:0]]*BiClass0';

%% Under ranking the  Class1
BiClass1=double(Err==1)';
Under_rank=[base_class.^[(N-1):-1:0]]*BiClass1';
Over_Under_rank=(Under_rank-Over_rank);



% %% Number of highly ranked Class1
% BiClass=predict_Class(class==1);
% High_rank=sum(BiClass')/max(size(class==1));


%

% accuracy0=Rank_weight'*(class==predict_Class);
% accuracy1=-norm(class-predict_Class);


%% Plot results
prediction=sortrows(Ranking_example,{'Class','Predicted'},'descend');

plot( 0.1*cnt* normalize(prediction.Predicted,'range'), 'LineWidth',1.5);hold on

 d=1;
   
 
 
 function Over_Under_rank=ORI_Accuracy(Class, predict_Class)
 
 
%% Version 2
N=max(size(Class));
RankH=sum(Class);
RankL=N-RankH;
base_class=max(size(unique(predict_Class)));
N1=sum(predict_Class(1:RankH));
N0=RankH-N1;
ps=0;

for k=1:N1
    ps=ps+(N0-k);
end
% p=[(N-1):-1:0]+ps;


p=[(N-1):-1:0]+2*N1;

%% Under ranking the  Class1
Over_Under_rank=(base_class.^p(1:RankH))*predict_Class(1:RankH)+  bi2de(fliplr(predict_Class(RankH+1:end)')) ;







 
