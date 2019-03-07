clear all; close all; 
addpath ./Function 

% names = {'0' '1' '2' '3','4','5','6','7','8'};
% A=[ 0 5 0 0 0 4 1 0 0  ;  % (0)
%     5 0 1 2 3 1 4 0 0  ;  % (1) 
%     0 1 0 10 0 0 0 7 3 ;  % (2)
%     0 2 10 0 0 0 1 1 0 ;  % (3) 
%     0 3 0 0 0 1 0 0 1  ;  % (4)
%     4 1 0 0 1 0 0 0 0  ;  % (5) 
%     1 4 0 1 0 0 0 0 0  ;  % (6) 
%     0 0 7 1 0 0 0 0 5  ;  % (7) 
%     0 0 3 0 1 0 0 5 0 ];  % (8)

%% M&M Experiemnt 
MNM_Experiment


Exist_edge=A;
Exist_edge(find(A~=0))=1;
Exist_edge_NC=A;
Exist_edge_NC(find(A~=0))=-inf;

% Plot the graph
figure;
G = graph(A,names,'upper','omitselfloops')
h=plot(G,'EdgeLabel',G.Edges.Weight,'MarkerSize',25)%,'LineWidth',G.Edges.Weight )
set(gca,'XTickLabel',[],'YTickLabel',[])
title('Occurence graph')
set(gca,'fontsize',16)



[U,S,V] =svd(A);

 Sigmas0=diag(S);   

%% Get the highter weights
% Score1
% Score1=V
% Score1=Score1.*Exist_edge ;
% Score1(find(Score1==0))=+inf;
% % Score1 = max(Score1,0);
% Score1_Rank=sort_matrix_values(Score1)
% % Plot the graph scores
% figure;
% 
% G1 = digraph(Score1_Rank.*Exist_edge,names)
% h=plot(G1,'EdgeLabel',G1.Edges.Weight,'MarkerSize',25)%,'LineWidth',G2.Edges.Weight )
% set(gca,'XTickLabel',[],'YTickLabel',[])
% title('Scoring using Singlar vector:  V')
% 
% 
% % Score2
% Score2=S*V
% Score2=Score2.*Exist_edge;
% Score2(find(Score2==0))=+inf;
% 
% % Score2 = max(Score2,0)
% Score2_Rank=sort_matrix_values(Score2)
% 
% % Plot the graph scores
% figure;
% G2 = digraph(Score2_Rank.*Exist_edge,names)
% h=plot(G2,'EdgeLabel',G2.Edges.Weight,'MarkerSize',25)%,'LineWidth',G2.Edges.Weight )
% set(gca,'XTickLabel',[],'YTickLabel',[])
% title('Scoring using: \Sigma * V')
% 



% Score3
Score2=S*V';
Score2=Score2+Score2';
Score2=Score2.*Exist_edge;
Score2(find(Score2==0))=+inf;

% Score2 = max(Score2,0)
Score2_Rank=sort_matrix_values(Score2)

% Plot the graph scores
figure;
G2 = graph(Score2_Rank.*Exist_edge,names)
h=plot(G2,'EdgeLabel',G2.Edges.Weight,'MarkerSize',25)%,'LineWidth',G2.Edges.Weight )
set(gca,'XTickLabel',[],'YTickLabel',[])
title('OCC- Scoring using: \Sigma * V + V* \Sigma ')


% Score4
Sigmas=Sigmas0;Sigmas(5:6)=0;
Score2=U*diag(Sigmas)*V'
Score2=Score2+Score2';
Score2=Score2.*Exist_edge;

Score2(find(Score2==0))=-inf;

% Score2 = max(Score2,0)
Score2_Rank=sort_matrix_values(-Score2)-1;
% Plot the graph scores
figure;
G2 = graph(Score2_Rank.*Exist_edge,names);
h=plot(G2,'EdgeLabel',G2.Edges.Weight,'MarkerSize',25);%,'LineWidth',G2.Edges.Weight )
set(gca,'XTickLabel',[],'YTickLabel',[])
title('OCC- Scoring using: U* \Sigma * V^T   ')

