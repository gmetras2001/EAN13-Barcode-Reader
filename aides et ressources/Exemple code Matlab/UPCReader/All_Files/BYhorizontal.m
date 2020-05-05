function c=BYhorizontal(horizantalRule,NumofRows,NumofColoms,I);

    j=1;
    b=[1:NumofColoms];   
	
    for x=1:NumofColoms
        if (I(round(NumofRows/horizantalRule),x)==0)
            b(j)=1;
            j=j+1;
        elseif (I(round(NumofRows/horizantalRule),x)==1)
            b(j)=0;
            j=j+1;
        end
    end
    
    c=b;