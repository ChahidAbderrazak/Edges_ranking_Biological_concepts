%% This script runs the SVD using diffferent weights as listed in the <Weight_name_list>

Weight_name_list={'ABFreq','FDR','ABab', 'PMI','Capacity','ABCFreq','Pvalue'};

mAP_op=0;
for k= 1:size(Weight_name_list,2)
    
    Weight_name=Weight_name_list{k};
    
    for symtry=1%0:1

        
            if symtry==0
                type='Dr'; 
                [Sparse_Data, Sparse_Data_diag]=Build_NONSymetric_SVD_matrix(Weight_name,Data_indexed_Blcd);

            else
                type='UnDr'; 
                [Sparse_Data, Sparse_Data_diag]=Build_Symetric_SVD_matrix(Weight_name,Data_indexed_Blcd);

            end
            
                    
        for S_diag=0%0:1
            
            if S_diag==1
                config=[type 'Diag']; 
                SVD_matrix_Data=Sparse_Data_diag;
                
            else
                config=type; 
                SVD_matrix_Data=Sparse_Data;
            end
M
            % Build SVD matrix
           

            % Score the Graph using  KSVD
            [ ScoreK3,Ranked_Adge, KSVD_K]=SVD_based_ranking(SVD_matrix_Data,Data_indexed_Blcd);

            [Results_prediction,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP ]= Find_Predicted_class(class,ScoreK3) ;           

            eval([strcat('Results_Comp.Sc',config,Weight_name,'=Results_prediction.Score;')]); 
            eval([strcat('Results_Comp.',config,Weight_name,'=Results_prediction.Predicted;')]); 

            Outcome(cnt,:)=[mAP accuracy Top1]  ;
            fprintf('%s- SVDK [%s]: Acc= %.2f,  Top%d mAP=%f,  [%.5e] K=%.2f \n-------------------------------------\n',Weight_name,config, accuracy,Top1, mAP,Over_Under_rank, KSVD_K)
            lgnd{cnt}=strcat('SVD__',config,'__',Weight_name);cnt=cnt+1;


            %% Get the optimal mAP
            if mAP>mAP_op
                mAP_op=mAP;
                accuracy_op=accuracy;
                Top1_op=Top1;
                Weight_name_op=Weight_name;
                config_op=config;
                KSVD_K_op=KSVD_K;
                Results_op=Results_prediction;
            end

        end
        
    end
    
end


fprintf('\n###    Optimal ###\n%s- SVDK [%s]: Accuracy= %.2f,  Top%d mAP=%.3f, KSVD=%.2f. \n-------------------------------------\n',Weight_name_op,config_op, accuracy_op,Top1_op, mAP_op, KSVD_K_op)

                
Outcome_T=array2table(lgnd(2:end)','VariableNames',{'EdgesWeights'});%,'Accuracy','TopRanked','ORI'});
Outcome_T.mAP=Outcome(2:end,1);
Outcome_T.Accuracy=Outcome(2:end,2);
Outcome_T.TopRanked=Outcome(2:end,3);

Outcome_T0=Outcome_T;
%% Save excel results 
Outcome_T = sortrows(Outcome_T,'mAP','descend');
writetable(Outcome_T,'./xlsx/mAP.xlsx')


