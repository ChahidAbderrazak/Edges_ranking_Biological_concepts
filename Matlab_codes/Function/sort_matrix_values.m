function M_Ranked=sort_matrix_values(M)

SYmtr=max(max(triu(M)-triu(M')));

% if SYmtr==0
%     MT=triu(M);
%     X=MT(:);
% else
%     X=M(:);
% 
% end

    X=M(:);

%% sort rank
[temp,X_ranked]  = ismember(X,unique(X));
%% Reshape
M_Ranked=  reshape(X_ranked, size(M));

% M_Ranked=triu(M_Ranked);
