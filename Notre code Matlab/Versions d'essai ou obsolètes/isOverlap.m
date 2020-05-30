function overlap = isOverlap(a,b,c,d)
    overlap=0;
    
    ab=[b(1)-a(1);b(2)-a(2)];  
    r=[-a(2),a(1)];
    %coordonnées du projeté du point c sur la droite (ab)
    Bc=[c;r]*ab;
    Ac=[ab,[0 1;-1 0]*ab];
    XC=Ac\Bc;
    %coordonnées du projeté du point d sur la droite (ab)
    Bd=[d;r]*ab;
    Ad=[ab,[0 1;-1 0]*ab];
    XD=Ad\Bd;
    
    %chevauchement si le point XC ou le point XD appartient au segment [ab]
    if a(1)>b(1)
        if (XC(1)<=a(1) && XC(1)>=b(1))||(XD(1)<=a(1) && XD(1)>=b(1))
            overlap=1;
        end
    else
        if (XC(1)>=a(1) && XC(1)<=b(1))||(XD(1)>=a(1) && XD(1)<=b(1))
            overlap=1;
        end
    end