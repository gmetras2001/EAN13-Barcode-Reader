function numG = decodeG(p,i)
numG=0;
    if (p(i)==1)& (p(i+1)==1) &(p(i+2)==2) &(p(i+3)==3)
                numG=0;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==2) &(p(i+3)==2)
                numG=1;  
            elseif (p(i)==2)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==2)
                numG=2;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==4) &(p(i+3)==1)
                numG=3;
            elseif (p(i)==2)& (p(i+1)==3) &(p(i+2)==1) &(p(i+3)==1)
                numG=4;
            elseif (p(i)==1)& (p(i+1)==3) &(p(i+2)==2) &(p(i+3)==1)
                numG=5;
            elseif (p(i)==4)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==1)
                numG=6;
            elseif (p(i)==2)& (p(i+1)==1) &(p(i+2)==3) &(p(i+3)==1)
                numG=7;
            elseif (p(i)==3)& (p(i+1)==1) &(p(i+2)==2) &(p(i+3)==1)
                numG=8;
            elseif (p(i)==2)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==3)
                numG=9;
            end
end