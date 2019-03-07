function  [Weights_vec, Results,Thshold_op_TN]=Apply_KSVD(K, Sparse_GraphM_TR, GraphM_TS)
 global N
[Scores_A,Ratio_k]=Score_K_SVD(Sparse_GraphM_TR, K);
 
% Scores_A=Scores_A-diag(diag(Scores_A));

%% Testing Data
% Score1
N=max(size(GraphM_TS));

class=GraphM_TS(:,3);
% Weights=zeros(N,4);
predict_Weights=zeros(N,1);


for k=1:N
  
    Idx=sort(GraphM_TS(k,1:2))
predict_Weights(k,1)=Scores_A(Idx(1),Idx(2))
end


[Weights_vec, Results,Thshold_op_TN]=optimal_threshold(predict_Weights,class,GraphM_TS);
d=1;

end






function [Weights_vec, Results,Thshold_op_TN]=optimal_threshold(Weights_vec,class,Exist_edge_to_Score)
 global N


Acc_op=0;TP_op=0;
for k=1:size(Weights_vec,2)
        Score=Weights_vec(:,k);

        for Thshold= linspace(min(Score),max(Score),100)
            
            Idx_high_rank= find(Score>Thshold);
            predict_Weights=zeros(N,1);
            predict_Weights(Idx_high_rank)= 1;



            % Computethe ranking performance 
            
            Err=class-predict_Weights;
            
            
            idx0=find(class==0);            Err0=class(idx0)-predict_Weights(idx0); TN=200* max(size(find(Err0==0)))/N  

            idx1=find(class==1);            Err1=class(idx1)-predict_Weights(idx1); TP=200* max(size(find(Err1==0)))/N 
            
            
            if TN>80 & TP_op<TP
                TP_op=TP;
                TN_op=TN;
                Thshold_op_TN=Thshold;
                score_idx_TN=k;
                
            end
                
                
            True= max(size(find(Err==0)));
%             Acc= 100*True/N
            Acc=mse(Err)
            if Acc_op<Acc
                Acc_op=Acc;
                Thshold_op=Thshold;
                score_idx=k;
                score_op=Weights_vec(:,score_idx);
                Results=[Exist_edge_to_Score(:,1:2) Weights_vec   class predict_Weights score_op];
            end

        end
    end
    Data_features=[Weights_vec   class ];

%     save(strcat('X_data',num2str(l),'.mat'),'Data_features')

    
Acc_op
TP_op
TN_op
Thshold_op_TN
end




