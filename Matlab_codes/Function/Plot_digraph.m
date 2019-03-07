function Plot_digraph(Scores, A)
global K 

% graph_matrix=ab_freq_ab_2_matrix(Adg_matrix);
N=size(Scores,1);
names = {'0', '1', '2' ,'3','4','5','6','7','8','9','10'};
G2 = digraph(Scores);


G1 = digraph(A);

figure;subplot(121);
    h1=plot(G1,'EdgeLabel',G1.Edges.Weight,'MarkerSize',30);%,'LineWidth',G2.Edges.Weight )
    % h.LineWidth = G1.Edges.Weight;
    set(gca,'XTickLabel',[],'YTickLabel',[])
    title('Occurance graph')

subplot(122);
    h2=plot(G2,'EdgeLabel',G2.Edges.Weight,'MarkerSize',25);%,'LineWidth',G22.Edges.Weight )
    set(gca,'XTickLabel',[],'YTickLabel',[])
    title(strcat(num2str(K),'% - SVD based Scoring'))

% highlight(h,G2,'EdgeColor','r','LineWidth',1.5)