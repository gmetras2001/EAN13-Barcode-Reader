function [valid,result]= decode(p,k)
    disp(p)
    disp(k)
    res1=decode1(p,k);
    res2=decode2(p,k);
    result=[res1 res2];
    if checkBarcode(result)
        valid=1;
    else
        valid=0;
    end
end