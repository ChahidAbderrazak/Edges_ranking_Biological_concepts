% this function assign to each concept in <Data> it corresponding
% Dictionary. THAN   sorts the  concepts by dictionary 

function [Concept2Dict, T_Concept2Dict]=Get_Concept2Dict(graph,Concepts,names)
fprintf('\n--> Assign to each concept the corresponding Dictionary.\n')



Concepts_pairs=[graph.concept_a graph.concept_b];  
Dicts_pairs=[graph.dict_a graph.dict_b];  
tic
Nc=max(size(Concepts)); 
Concept2Dict=zeros(Nc,2);
Concept2Dict(:,1)=Concepts;

%% Initialize dictionaries
Dicts=zeros(Nc,1);

parfor k=1:Nc

    Idx=find(graph.concept_a==Concepts(k));
    idx_dic=1;
    
    if size(Idx,1)==0
       Idx=find(graph.concept_b==Concepts(k));
       idx_dic=2;    
    end
    Dicts(k)=unique(Dicts_pairs(Idx,idx_dic));
        
    Freq(k)=graph.ab_freq(Idx(1));
d=1;
end

Concept2Dict(:,2)=Dicts;
Concept2Dict(:,3)=Freq;
Concept2Dict(:,4)=Freq./sum(Freq);

toc

% sort concepts by dictionary
% Concept2Dict=sortrows(Concept2Dict,2);
[Concept2Dict,index] =sortrows(Concept2Dict,2);

nodes=1:Nc;
Concept2Dict=[Concept2Dict, nodes'];

T_Concept2Dict=array2table(Concept2Dict,'VariableNames',{'Concept','Dict','Freq','Prob','Node'});


snames = string(names{:, end});
Names_T=table2array(names(:,1));                    % convert table to matrix


parfor k=1:Nc
    idx=find(Concept2Dict(k,1)==names.concept_id)
    Concepts_names{k,:}=names.name(idx);
end
T_Concept2Dict.NameConcept=Concepts_names;
d=1;


