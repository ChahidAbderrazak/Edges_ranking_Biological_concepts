
clear all; close all; addpath ./Function 

%% Build the graph
M=20
N=3;
A=randi([0 1],M,N)
A_table=array2table(A)

[U,S,V] =svds(A);
figure;scatter(A(:,1),A(:,2));hold on; scatter(U(:,1),U(:,2))


figure;histogram(A(:,1),M);hold on;histogram(A(:,2),M); legend('Dim1','Dim2')

A
U 
S
V

% 
S1=S;S1(2,2:end)=0

A2=U*S1*V;
Q=S1*V';

QX = Q(:,1);                                            % Isolate Line �x� Coordinates
QY = Q(:,2);                                            % Isolate Line �y� Coordinates
[~,UV] = gradient(Q);                                   % Generate Gradient
UVX = [UV(1,1); 0];                                     % Define Quiver Arrow �x�
UVY = [UV(1,2); 0];                                     % Define Quiver Arrow �y�
figure;
% plot(QX, QY, '-r', 'LineWidth',1.2)                     % Plot Line (Optional)
hold on
quiver(QX, QY, UVX, UVY, 0)
hold off
% axis([-0.15  1.1    -0.15  0.2])
axis equal
grid


% %% Build the graph
% A=zeros(4);
% A=A - diag(diag(A));
% A(1,2)=4;
% % A(1,6)=2;
% A(2,3)=5;
% A(2,4)=6;
% % A(2,6)=2;
% A(3,4)=M;
% % A(5,6)=15;
% 
% A=A+A';
% A(A<=1)=0
% % A(4,4)=M
% 
% % A(4,4)=M
% % A=A+diag(sum(A));
% A=(A-min(min(A)))/max(max(A))
% 
% 
%  
%  
% % global K
% % 
% % K=60;
% % [A0_sorted,Ratio_k]=Score_K_SVD(A, K);
% 
% % % %% the meaning of the decomposition
% % %  [U,S1,V] =svds(A);
% % % 
% % % x=[0 1 1 0]';
% % % P23=V*x
% % % P23N=norm(P23.*(x.*S1))
% % % 
% % % x=[0 0 1 1]';
% % % P34=V*x
% % % P34N=norm(P34.*(x.*S1))
% % % 
% % % x=[1 1 0 0]';
% % % P12=V*x
% % % P12N=norm(P12.*(x.*S1))
% % % 
% % % x=[1 0 0 1 ]';
% % % P14=V*x
% % % P14N=norm(P14.*(x.*S1))
% % % 
% % % 
% % % x=[1 0 1 0 ]';
% % % P13=V*x
% % % P13N=norm(P13.*(x.*S1))
% % % 
% % % A
% % % 
% % % P23N;
% % % P34N
% % % P12N
% % % P14N
% % % P13N