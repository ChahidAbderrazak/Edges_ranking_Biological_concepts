function TS_Data_indexed_Blced=Get_Balanced_TS(TS_Data_indexed)

Ind0=find(TS_Data_indexed(:,3)==0);Ind1=find(TS_Data_indexed(:,3)==1);
N_TS=min(size(Ind1),size(Ind0));
TS_Data_indexed_Blced=[TS_Data_indexed(Ind0(1:N_TS),:);TS_Data_indexed(Ind1(1:N_TS),:);];


end