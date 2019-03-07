function [U,S,V,Score1,Score2,Score3]=SVD_Ranking(A)

names=string(1:size(A,1));

Exist_edge=A;
Exist_edge(find(A~=0))=1;
Exist_edge_NC=A;
Exist_edge_NC(find(A~=0))=-inf;

% Plot the graph
% figure;
% G = graph(A,names,'upper','omitselfloops')
% h=plot(G,'EdgeLabel',G.Edges.Weight,'MarkerSize',25)%,'LineWidth',G.Edges.Weight )
% set(gca,'XTickLabel',[],'YTickLabel',[])
% title('Occurence graph')
% set(gca,'fontsize',16)



[U,S,V] =svds(A);

    



% Score2
Score2=S*V
Score2=Score2.*Exist_edge;
Score2(find(Score2==0))=+inf;

% Score2 = max(Score2,0)
Score2_Rank=sort_matrix_values(Score2)

% Plot the graph scores
figure;
G2 = digraph(Score2_Rank.*Exist_edge,names)
h=plot(G2,'EdgeLabel',G2.Edges.Weight,'MarkerSize',25)%,'LineWidth',G2.Edges.Weight )
set(gca,'XTickLabel',[],'YTickLabel',[])
title('Scoring using: \Sigma * V')




% Score3
Score3=S*V
Score3=Score3+Score3';
Score3=Score3.*Exist_edge;
Score3(find(Score3==0))=+inf;

% Score3 = max(Score3,0)
Score3_Rank=sort_matrix_values(Score3)

% Plot the graph scores
figure;
G2 = graph(Score3_Rank.*Exist_edge,names)
h=plot(G2,'EdgeLabel',G2.Edges.Weight,'MarkerSize',25)%,'LineWidth',G2.Edges.Weight )
set(gca,'XTickLabel',[],'YTickLabel',[])
title('OCC- Scoring using: \Sigma * V + V* \Sigma ')

end