names = {'R' 'Bl' 'Y' 'G','Br','O'};
MNM=  [ 5 2 1 2 1 1   ;  % (0)
        2 4 1 3 0 1  ;  % (1) 
        1 1 5 4 1 1 ;  % (2)
        2 3 4 7 1 2 ;  % (3) 
        1 0 1 1 2 1  ;  % (4)
        1 1 1 2 1 3  ];  % (5) 


% Plot the graph
figure;
G = graph(MNM,names,'upper','omitselfloops')
h=plot(G,'EdgeLabel',G.Edges.Weight,'MarkerSize',25)%,'LineWidth',G.Edges.Weight )
set(gca,'XTickLabel',[],'YTickLabel',[])
title('Occurence graph')
set(gca,'fontsize',16)



PorbMNM=[5 4 5 7 2 3];
MNM=PorbMNM'*PorbMNM;

MNM=MNM - diag(diag(MNM));
A=MNM;

