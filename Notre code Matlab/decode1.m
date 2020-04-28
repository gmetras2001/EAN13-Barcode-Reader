function res1 = decode1(p,k,table)
    res1 = [1:6];
    
    res1(1)=decodeL(p,k+3);
    
    if table==0 || table==1 || table==2 || table==3 || table==9 
        res1(2)=decodeL(p,k+7);
    else
        res1(2)=decodeG(p,k+7);
    end
    
    if table==0 || table==4 || table==7 || table==8
        res1(3)=decodeL(p,k+11);
    else
        res1(3)=decodeG(p,k+11);
    end
    
    if table==0 || table==1 || table==4 || table==5 || table==9
        res1(4)=decodeL(p,k+15);
    else
        res1(4)=decodeG(p,k+15);
    end
    
    if table==0 || table==2 || table==5 || table==6 || table==7
        res1(5)=decodeL(p,k+19);
    else
        res1(5)=decodeG(p,k+19);
    end
    
    if table==0 || table==3 || table==6 || table==8 || table==9
        res1(6)=decodeL(p,k+23);
    else
        res1(6)=decodeG(p,k+23);
    end
end