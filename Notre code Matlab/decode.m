function result= decode(p,k)
    res2=decode2(p,k);
    for i=0:9
        res1=decode1(p,k,i);
        result=[res1 res2];
        if checkBarcode(result,i)
            disp('code barre valide')
            table=i;
            break;
        end
    end
    result = [table result];
    if checkBarcode(result,i)
        disp('code non valide')
    end
end