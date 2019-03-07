% It rus a k-folds cross validation using some inpur features and their
% corresponding sequances that will be used to genarate PWM feature using PWM_Ratio
% The output results return the optimal Logestic regressin model that gives the
% maximum accuracy in classifying the combined features [ input features + PWM]
% Important: the Pos_Sequences must be used to generate the  Pos_feature
% with the same order. Respctivelly for Neg_Sequences-->Neg_features

function  [Mdl_optimal,Acc_Max, CV_results, CV_Accuracy]=Run_Cross_Validation_of_features(nb_folds,Combined_TR)

%% Create the partitions
cnt0=0;Acc_Max=0;
fprintf(' --------------------------------------------------------------------------------\n')
fprintf('| The Cross Validation training is running using %d Fold   \n',nb_folds)
fprintf(' --------------------------------------------------------------------------------\n')


M=size(Combined_TR,1);

group=string(strcat(num2str(Combined_TR(:,end)),'e'));
CVO = cvpartition(group,'k',nb_folds)%,'Stratify',true)

if nb_folds>1
    
    for k = 1:CVO.NumTestSets

%         fprintf('\n----- Fold %d  ----\n',k)
        trIdx = CVO.training(k);
        teIdx = CVO.test(k);
    
        
        X_train_k=Combined_TR(trIdx,:);
        X_test_k =Combined_TR(teIdx,:);
        
        Sz_0=max(size(find(X_test_k(:,end)==0))); Sz_1=max(size(find(X_test_k(:,end)==1)));
        balanced_TS=Sz_0-Sz_1
               
        Sz_0=max(size(find(X_train_k(:,end)==0))); Sz_1=max(size(find(X_train_k(:,end)==1)));
        balanced_TR=Sz_0-Sz_1 
        

        [Mdl,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,ytrue00,yfit00,C]=Test_Training_LR(X_train_k,X_test_k);

        %% Run the logitic regression 
        cnt0=cnt0+1;
        CV_results(cnt0,:)=[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,C];  

        if Acc_Max<accuracy0
            Mdl_optimal=Mdl;   Acc_Max=accuracy0;

        end



    end
    CV_Accuracy = sum(CV_results(:,1))/nb_folds;
else
    
    
        [Mdl_optimal]=Training_LR(Combined_TR);
        
        [accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=Test_LR(Mdl_optimal,Combined_TR);

        %% Run the logitic regression 
        cnt0=cnt0+1;
        CV_results(cnt0,:)=[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0];  
        CV_Accuracy=accuracy0;
        
        
    
    
end

d=1;





