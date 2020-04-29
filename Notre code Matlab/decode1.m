function res1 = decode1(p,k)
    res1 = [1:7];
    table = zeros(1,6);
    j=1;
    %decodage du 2ème au 7ème chiffre
    for i=k+3:4:k+23
        j=j+1;
        if (p(i)==3)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==1)
            res1(j)=0;
        elseif (p(i)==2)& (p(i+1)==2) &(p(i+2)==2) &(p(i+3)==1)
            res1(j)=1;  
        elseif (p(i)==2)& (p(i+1)==1) &(p(i+2)==2) &(p(i+3)==2)
            res1(j)=2;
        elseif (p(i)==1)& (p(i+1)==4) &(p(i+2)==1) &(p(i+3)==1)
            res1(j)=3;
        elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==3) &(p(i+3)==2)
            res1(j)=4;
        elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==3) &(p(i+3)==1)
            res1(j)=5;
        elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==4)
            res1(j)=6;
        elseif (p(i)==1)& (p(i+1)==3) &(p(i+2)==1) &(p(i+3)==2)
            res1(j)=7;
        elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==3)
            res1(j)=8;
        elseif (p(i)==3)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==2)
            res1(j)=9;
        else
            if (p(i)==1)& (p(i+1)==1) &(p(i+2)==2) &(p(i+3)==3)
                res1(j)=0;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==2) &(p(i+3)==2)
                res1(j)=1;  
            elseif (p(i)==2)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==2)
                res1(j)=2;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==4) &(p(i+3)==1)
                res1(j)=3;
            elseif (p(i)==2)& (p(i+1)==3) &(p(i+2)==1) &(p(i+3)==1)
                res1(j)=4;
            elseif (p(i)==1)& (p(i+1)==3) &(p(i+2)==2) &(p(i+3)==1)
                res1(j)=5;
            elseif (p(i)==4)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==1)
                res1(j)=6;
            elseif (p(i)==2)& (p(i+1)==1) &(p(i+2)==3) &(p(i+3)==1)
                res1(j)=7;
            elseif (p(i)==3)& (p(i+1)==1) &(p(i+2)==2) &(p(i+3)==1)
                res1(j)=8;
            elseif (p(i)==2)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==3)
                res1(j)=9;
            end
            table(j-1)=1;
        end
    end
    %decodage du premier chiffre
    if table==[0 0 0 0 0 0]
            res1(1)=0;    
    elseif table==[0 0 1 0 1 1]
            res1(1)=1;    
    elseif table==[0 0 1 1 0 1]
            res1(1)=2;    
    elseif table==[0 0 1 1 1 0]
            res1(1)=3;    
    elseif table==[0 1 0 0 1 1]
            res1(1)=4;    
    elseif table==[0 1 1 0 0 1]
            res1(1)=5;    
    elseif table==[0 1 1 1 0 0]
            res1(1)=6;    
    elseif table==[0 1 0 1 0 1]
            res1(1)=7;    
    elseif table==[0 1 0 1 1 0]
            res1(1)=8;    
    elseif table==[0 0 1 0 1 0]
            res1(1)=9;
    end
end