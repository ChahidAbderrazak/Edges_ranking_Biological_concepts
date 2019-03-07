function [A0_sorted,Ratio_k,U,S,V]=Score_K_SVD(A, K)
%% Use SVD to rank
tic
 [U,S,V] =svds(A);
toc



%% Get  the K singular value with respect to the 
S1=diag(S);
S1=diag(S);
% K=S1<S1(1)/4
Selected_Singular_Values=S1*0;

for k=1:max(size(Selected_Singular_Values))
    
    S1=diag(S);
    Selected_Singular_Values(end-k+1:end)=1;
    S1(Selected_Singular_Values==1)=0;
    Ratio_k=100*sum(S1)/sum(diag(S));
    
    if Ratio_k<K
        S1=diag(S);
        Selected_Singular_Values=S1*0;
        Selected_Singular_Values(end-(k-1)+1:end)=1;

        break;
    end

end

% Selected_Singular_Values=[0 0 1 1 1 1 ]';

S1=diag(S);
S1(Selected_Singular_Values==1)=0;
Ratio_k=100*sum(S1)/sum(diag(S));

        
A0=U*diag(S1)*V';
% A0=U*diag(Selected_Singular_Values)*V'

A0=A0 - diag(diag(A0));

% A0_sorted=sort_matrix_values(-A0)
A0_sorted=sort_TriangUp_matrix_values(-A0);



% triu(A)
% 
% S1
% d=1;
% 
% A0_sorted(A0_sorted>=12)=0
% 
% % Plot_graph(A);
% Plot_digraph(A0_sorted,A);
% 