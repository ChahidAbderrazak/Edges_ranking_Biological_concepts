function R=rank_binary_sequence(X)

Seq=X';

N=max(size(X));
N1=sum(X);
N0=N-N1;

if N0==0 | N1 ==0
    
    R=0;
    
% elseif N0==1 | N1 ==1
%     
%     R=100001;
    
    
    
else
    
    
    Idx1=find(X==1);Idx10=min(Idx1);
    Idx0=find(X==0);


    Idx=Idx1(find(Idx1> min(Idx0)));


    % SeqL=Seq(2:end);
    if min(size(Idx))==0
        Idx=min(Idx1);
    end

    

    if  min(Idx1)< min(Idx0)
    Idx=Idx0(1);
    end


    if min(Idx0)==N
        Idx=Idx1(1);
    end

    
    SeqL=Seq(Idx:end);
%     IdxL0=find(SeqL==0); 
%     IdxL1=find(SeqL==1); 
% 
%     if size(IdxL0,1)~=0 & min(IdxL0)==N
%         SeqL=SeqL(IdxL1(1):end);
%     end

   %% R2: this score is related  lower ranks with the same number  ones in the High ranks region [left]
        n1=sum(SeqL);
        n=max(size(SeqL));
        if n1>0
            R2=nchoosek(n,n1);
            
            
            
        else
            R2=0;
            
            
        end
        
    %% R1: this score is related  lower ranks with the same raning in High ranks region

    if max(size(Idx1))>=2   & min(Idx1)==1   
        
%         if min(Idx1)==1
            SeqH=Seq(2:end);
%         else
%             SeqH=Seq(Idx1(2):end);
%         end
        
        n1=sum(SeqH);
        n=max(size(SeqH));
        if n1<n
            R1=nchoosek(n,n1+1);
            
        else
            R1=0;
        end

    else
    %%  Compute R1
        R1=0;
       
    end
        

    R=R1 +R2;
end

R;
d=1;













% % Over_Under_rank=log(Over_Under_rank)/log(base_class);
% 
% 
% 
% %% Compute the rank of the sequences amoung other sequances
% rank_vect=predict_Class'
% N1=sum(Class);
% H= predict_Class(1:RankH);
% L= predict_Class(RankH+1:end);
% 
% n1=sum(H);m1=n1-1;
% 
% % if m1<0
% %     R=1;
% % else
% % 
% %     R_H=rank_binary_sequence(H);
% %     R_L=rank_binary_sequence(L);
% % end
% %     
% 
% if m1<0
%     R=1;
% else
%     %% this score is related  lower ranks with loweer number of ones in High ranks region
%     r_lower=1;
%     
%     for k=m1:-1:1
%         
%             r_lower=r_lower+nchoosek(RankH,m1)*nchoosek(RankL,RankH-m1);
%     end
%     r_lower;
%     %% this score is related  lower ranks with the same number  ones in High ranks region
%     IdxH=min(find(H==1));
%     IdxL=min(find(L==1));
%     
%     H0= H(IdxH:RankH);NH0=max(size(H0));  nh0=sum(H0);
%     
%     L0= L(IdxL:end)  ;NL0=max(size(L0));  nl0=sum(L0);
%     
%     r_L= nchoosek(NH0,nh0)*nchoosek(NL0,nl0);
% 
% 
%   %% this score is related  lower ranks with the same raning in High ranks region
% %     r_L= nchoosek(NH0,nh0)*nchoosek(NL0,nl0)
% 
%         
% %     r=nchoosek(NH0,n1)*nchoosek(RankL,RankH-n1)
% 
%     R=r_lower + r_L;
%     
%     d=1;
% end

