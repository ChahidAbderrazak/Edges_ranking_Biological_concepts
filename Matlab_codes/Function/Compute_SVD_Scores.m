function Weights = Compute_SVD_Scores(num_score, Edges_To_Rank, U, S, V)

global T_Concept2Dict

Exist_edge_to_Score=table2array(Edges_To_Rank(:,{'NodeA','NodeB'}));

    for k=1:size(Exist_edge_to_Score,1)

            a=Exist_edge_to_Score(k,1); b=Exist_edge_to_Score(k,2);
            
            Ua=U(a,:);
            Ub=U(b,:);
            
            Va=V(a,:);
            Vb=V(b,:);
%             Uab=U(a,b);

%             Ua=Ua-min(Ua);Va=Va-min(Va);
%             Ub=Ub-min(Ub);Vb=Vb-min(Vb);
%             


    %         S=diag(Ws);%.*S;
            %% Get the score0
%             Scores=norm(Ua.*Ub);
                

            %% Get the score1
            Scores=Score_U_V_S1(num_score, S, Ua,Ub, Va,Vb);

            %% Get the score2
%             Scores=Score_U_V_S2(num_score, S, Ua,Ub, Va,Vb);

           
            
            Weights(k,:)=  sum(Scores(:));
            
            if Scores==-inf
                break;
            end

    end
        
Weights= unique(Weights', 'rows')';

% num_score

% N_levels=max(size(unique(Weights(:,1))))

d=1;

        
function  Scores=Score_U_V_S1(num_score, S, Ua,Ub, Va,Vb,Uab)

%% Select only the concepts stenghts related to a and b
    max_a=min(find(Ua==max(Ua)));
    max_b=min(find(Ub==max(Ub)));
    Ws(max_a)=1;
    Ws(max_b)=1;
            
            
    switch num_score
        
                case 1
%                     Scores=Ua(max_a)*Ub(max_b);
                    Scores=[Va ;Vb]';
                case 2
                    Scores=S*[Va ;Vb]';
                case 3
                    Scores=[Ua ;Ub]*S*[Va ;Vb]';
                    
                    
                case 4
                    Scores=[Ua ;Ub]*diag(S);

                case 5
                    Scores=Va*Vb';
                case 6
                    Scores=Ua*Ub' + Va*Vb';

                case 7
                    Scores=[Va ;Vb]'*[Ua ;Ub]*diag(S);
                    
                    %%-------------------------------------------------------------

 
                case 8
                    Scores=[Ua]*S*[Vb]';
                    
                    
                case 9
                    Scores=[Ua]*diag(S);

                case 10
                    Scores=Ua*Ub';
                    
%                     
%                 case 11
%                     Scores=Uab;    
%                     
                    
                otherwise
%                     Scores=-inf;
                    
                    Scores=Score_U_V_S2(num_score-10, S, Ua,Ub, Va,Vb);
                    
                    
            
    end


    
          
function  Scores=Score_U_V_S2(num_score, S, Ua,Ub, Va,Vb)

%% Select only the concepts stenghts related to a and b
    max_a=find(Ua==max(Ua));
    max_b=find(Ub==max(Ub));
    Ws(max_a)=1;
    Ws(max_b)=1;
    
    
            switch num_score

                case 1
                    Scores=Ua(max_a)*Ub(max_b);

                case 2
                    Scores=Ua*S*Ub';
                    
                case 3
                  
                    Scores=[Ua ;Ub]*diag(S);

                case 4
                    Scores=Ua*Ub';


                case 5
                    Scores=Ua.*Ub*diag(S);
                
               case 6
                    Scores=Ua(max_a)*Ub(max_b);
                    
               case 7
                    Scores=Ua*Ub' + Va*Vb';
                    
               case 8
                    Scores=Va*Vb';
                    
                            

                otherwise
                    Scores=-inf;
            end
        
