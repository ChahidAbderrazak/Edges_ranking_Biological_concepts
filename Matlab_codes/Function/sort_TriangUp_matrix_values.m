function M_Ranked=sort_TriangUp_matrix_values(M)

MT=triu(M);
X=MT(:);


%% sort rank
[temp,X_ranked]  = ismember(X,unique(X));
%% Reshape
M_Ranked=  reshape(X_ranked, size(M));

M_Ranked=triu(M_Ranked);
