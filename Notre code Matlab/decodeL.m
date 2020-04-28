function numL = decodeL(p,i)
numL=0;
    if (p(i)==3)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==1)
                numL=0;
            elseif (p(i)==2)& (p(i+1)==2) &(p(i+2)==2) &(p(i+3)==1)
                numL=1;  
            elseif (p(i)==2)& (p(i+1)==1) &(p(i+2)==2) &(p(i+3)==2)
                numL=2;
            elseif (p(i)==1)& (p(i+1)==4) &(p(i+2)==1) &(p(i+3)==1)
                numL=3;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==3) &(p(i+3)==2)
                numL=4;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==3) &(p(i+3)==1)
                numL=5;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==4)
                numL=6;
            elseif (p(i)==1)& (p(i+1)==3) &(p(i+2)==1) &(p(i+3)==2)
                numL=7;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==3)
                numL=8;
            elseif (p(i)==3)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==2)
                numL=9;
            end
end