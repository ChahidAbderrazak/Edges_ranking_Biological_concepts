function Plot_graph(A)

% graph_matrix=ab_freq_ab_2_matrix(Adg_matrix);
N=size(A,1);
names = {'0', '1', '2' ,'3','4','5','6','7','8','9','10'};


G1 = graph(A);

figure;
h=plot(G1,'EdgeLabel',G1.Edges.Weight,'MarkerSize',30);%,'LineWidth',G2.Edges.Weight )
% h.LineWidth = G1.Edges.Weight;
set(gca,'XTickLabel',[],'YTickLabel',[])
title('Occurance graph')
