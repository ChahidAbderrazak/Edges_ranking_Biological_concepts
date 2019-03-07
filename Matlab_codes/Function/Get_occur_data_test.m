function TS_Data_class_occ=Get_occur_data_test(TS_Data_indexed,Data_indexed)
N=size(TS_Data_indexed,1);
for k=1:N
    
    Idx=find(Data_indexed(:,1)==TS_Data_indexed(k,1) & Data_indexed(:,2)==TS_Data_indexed(k,2));
    Idx1=find(Data_indexed(:,2)==TS_Data_indexed(k,1) & Data_indexed(:,1)==TS_Data_indexed(k,2));

    if size(Idx,1)~=0       
        TS_Data_class_occ(k,:)=Data_indexed(Idx,3:end);
    end
    
     if  size(Idx1,1)~=0
        TS_Data_class_occ(k,:)=Data_indexed(Idx1,3:end);
     end
    
    
end



% TS_Data_class_occ=[TS_Data_indexed TS_Data_class_occ];

d=1;
