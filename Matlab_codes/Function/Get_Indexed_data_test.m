% this function assign to each concept in <Data> it  new idex related to the 
% corresponding sorted Dicionaries 

function [Data_indexed_GR]=Get_Indexed_data_test(Col_num, graph, groundtruth,Concept2Dict)

fprintf('\n--> Extract the Sub-Graph for the Groundtruth...\n')

%% 
Data=table2array(groundtruth(:,2:3));                    % convert table to matrix
sClass = string(groundtruth{:, 4});
Idx=find(sClass=='Yes');
N=size(Data,1);
Ng=size(graph,1);

Class=zeros(N,1);
Class(Idx)=1;
Class_GR=-ones(Ng,1);
concept_a=zeros(N,1);
concept_b=zeros(N,1);


for k=1:N
    
    EdgeNumber(k)=groundtruth.VarName1(k);
    swipp=0;
    Idx_a=find(Concept2Dict.Concept== groundtruth.concept_a(k));
    Idx_b=find(Concept2Dict.Concept==groundtruth.concept_b(k));
    
    concept_a(k)=Concept2Dict.Node(Idx_a);
    concept_b(k)=Concept2Dict.Node(Idx_b);
    
    %% build the adjacent matrix       
    Idxa=find(graph.concept_a==groundtruth.concept_a(k));
    Idxb=find(graph.concept_b==groundtruth.concept_b(k));
    Idx=intersect(Idxb,Idxa);
        
    if size(Idx,1)==0 | size(Idx,2)==0
        
    Idxb=find(graph.concept_b==groundtruth.concept_a(k));
    Idxa=find(graph.concept_a==groundtruth.concept_b(k));
    Idx=intersect(Idxb,Idxa);
    
    swipp=1;
      
    end
    

            
    if (size(Idxa,1)~=0 & size(Idxb,1)~=0)
        if swipp==0
            
            concept_a0(k)=graph.concept_a(Idx);
            concept_b0(k)=graph.concept_b(Idx);
            a_freq(k)=graph.a_freq(Idx);
            b_freq(k)=graph.b_freq(Idx);
            dict_a(k)=graph.dict_a(Idx);
            dict_b(k)=graph.dict_b(Idx);

            
        else
            
            concept_a0(k)=graph.concept_b(Idx);
            concept_b0(k)=graph.concept_a(Idx);
            a_freq(k)=graph.b_freq(Idx);
            b_freq(k)=graph.a_freq(Idx);
            dict_b(k)=graph.dict_a(Idx);
            dict_a(k)=graph.dict_b(Idx);
        end
        
        nameconcept_a{k}=Concept2Dict.NameConcept{Idx_a};
        nameconcept_b{k}=Concept2Dict.NameConcept{Idx_b};
        ab_freq(k)=graph.ab_freq(Idx);
        p_value(k)=graph.p_value(Idx);
        fdr(k)=graph.fdr(Idx);
        
        
        if groundtruth.valid(k)=='Yes'
            
            IdxG1(k)=Idx;
            
        else
            IdxG0(k)=Idx;
            
        end
    end
    
    
    %% build the adjacent matrix    
d=1;
end

%% Build extra  SCores
PMI=ab_freq./(a_freq.*b_freq);
Cap=ab_freq./(a_freq + b_freq);

%% Compute the concepts proboability 
Total_Freq=sum(Concept2Dict.Freq);
a_Prob=a_freq./Total_Freq;
b_Prob=b_freq./Total_Freq;
ABab=ab_freq.*a_Prob.*b_Prob;

%% add the class ro the graph
Class_GR(IdxG1(IdxG1~=0))=1;
Class_GR(IdxG0(IdxG0~=0))=0;

graph.Class=Class_GR;
%% Build the indexed Data classes
Data_indexed=[EdgeNumber' concept_a concept_b Class];
Data_indexed=array2table(Data_indexed,'VariableNames',{'EdgeNumber','NodeA','NodeB','Class'});
Sparse_Data_Class=Build_Symetric_Sparse(concept_a,concept_b, Class);

Edges=table2array(Data_indexed(:,{'NodeA','NodeB'}));
% wights=Get_AB_freq(Edges, Sparse_Data_Graph);
% 
% Sparse_Data_Weight=Build_Symetric_Sparse(concept_a,concept_b, wights);

%% Build the indexed Data classes
Data_indexed_GR=[EdgeNumber' Edges  dict_a' dict_b' a_freq' a_Prob' b_freq' b_Prob' ab_freq' p_value' fdr' PMI' Cap' ABab' ];
Data_indexed_GR=array2table(Data_indexed_GR,'VariableNames',{'EdgeNumber', 'NodeA','NodeB','Dict_A','Dict_B', 'AFreq', 'AProb','BFreq','BProb','ABFreq','Pvalue','FDR','PMI','Capacity','ABab'});

Data_indexed_GR=Get_relative_abFreq(Data_indexed_GR);


Data_indexed_GR.concept_a=concept_a0';
Data_indexed_GR.concept_b=concept_b0';
Data_indexed_GR.NameNodeA=nameconcept_a';
Data_indexed_GR.NameNodeB=nameconcept_b';
Data_indexed_GR.Class=Class;

d=1;



function Data_indexed_k=Get_relative_abFreq(Data_indexed_k)


Concept_list=unique([Data_indexed_k.NodeA; Data_indexed_k.NodeB])';
% INitialization
Data_indexed_k.Pa=0*Data_indexed_k.NodeA;
Data_indexed_k.Pb=Data_indexed_k.Pa;

for Concept=Concept_list
    Data_indexed_k=normalize_weight(Concept,Data_indexed_k);
    
end

% Data_indexed_k.ABCFreq=1./(Data_indexed_k.Pa.*Data_indexed_k.Pb);%.*;Data_indexed_k.ABFreq.
Data_indexed_k.ABCFreq=1./(Data_indexed_k.Pa+Data_indexed_k.Pb);%.*;



