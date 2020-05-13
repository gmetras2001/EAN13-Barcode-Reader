function rect = findBoundingBox(I)
    a=[0 0];
    stop=0;
    for i=1:size(I,1)
        for j=1:size(I,2)
            if I(i,j)
                a(1,1)=i;
                a(1,2)=j;
                stop=1;
                break;
            end
        end
        if stop
            break;
        end
    end
    
    b=[0 0];
    stop=0;
    for j=size(I,2):-1:1
        for i=1:size(I,1)
            if I(i,j)
                b(1,1)=i;
                b(1,2)=j;
                stop=1;
                break;
            end
        end
        if stop
            break;
        end
    end
    c=[0 0];
    stop=0;
    for i=size(I,1):-1:1
        for j=1:size(I,2)
            if I(i,j)
                c(1,1)=i;
                c(1,2)=j;
                stop=1;
                break;
            end
        end
        if stop
            break;
        end
    end
    d=[0 0];
    stop=0;
    for j=1:size(I,2)
        for i=1:size(I,1)
            if I(i,j)
                d(1,1)=i;
                d(1,2)=j;
                stop=1;
                break;
            end
        end
        if stop
            break;
        end
    end
    %marge de m pixels (ou moins) à gauche et à droite
    m = 200;
    if d(1,2)-m<0
        A = 0;
        C = b(1,2)-d(1,2)+d(1,2);
        if C+m<size(I,2)
            C=C+m;
        else
            C = size(I,2);
        end
    else
        A = d(1,2)-m;
        C = b(1,2)-d(1,2)+m;
        if d(1,2)+C+m<size(I,2)
            C=C+m;
        else
            C = size(I,2)-A;
        end
    end
    %marge de m pixels (ou moins) en haut et en bas
    if a(1,1)-m<0
        B = 0;
        D = c(1,1)-a(1,1)+a(1,1);
        if D+m<size(I,1)
            D = D+m;
        else
            D = size(I,1);
        end
    else
        B = a(1,1)-m;
        D = c(1,1)-a(1,1)+m;
        if a(1,1)+D+m<size(I,1)
            D=D+m;
        else
            D=size(I,1)-B;
        end
    end
    rect = [A B C D];
end