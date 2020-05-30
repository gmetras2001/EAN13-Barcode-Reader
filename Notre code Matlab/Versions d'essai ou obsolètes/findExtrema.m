function [a,b] = findExtrema(c,L,o)
    L=L/2;
    v=L*[cosd(o) sind(o)];
    a=c-v;
    b=c+v;
end