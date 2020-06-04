function [valid,result]= decode(p,k)
    [v1,res1]=decode1(p,k);
    [v2,res2]=decode2(p,k);
    result=[res1 res2];
    if checkBarcode(result)&& v1 && v2
        valid=1;
    else
        valid=0;
    end
end