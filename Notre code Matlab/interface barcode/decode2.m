function res2 = decode2(p,k)
        res2=[1:6];
        h=0;
        for i=(k+32):4:(k+52)
            h=h+1;
            if (p(i)==3)& (p(i+1)==2) & (p(i+2)==1) & (p(i+3)==1)
                res2(h)=0;
            elseif (p(i)==2)& (p(i+1)==2) &(p(i+2)==2) &(p(i+3)==1)
                res2(h)=1;  
            elseif (p(i)==2)& (p(i+1)==1) &(p(i+2)==2) &(p(i+3)==2)
                res2(h)=2;
            elseif (p(i)==1)& (p(i+1)==4) &(p(i+2)==1) &(p(i+3)==1)
                res2(h)=3;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==3) &(p(i+3)==2)
                res2(h)=4;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==3) &(p(i+3)==1)
                res2(h)=5;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==4)
                res2(h)=6;
            elseif (p(i)==1)& (p(i+1)==3) &(p(i+2)==1) &(p(i+3)==2)
                res2(h)=7;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==3)
                res2(h)=8;
            elseif (p(i)==3)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==2)
                res2(h)=9;
            end
        end
end