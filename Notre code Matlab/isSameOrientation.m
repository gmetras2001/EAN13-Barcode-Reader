%orientation o1 et o2 entre -90 et 90
function orientationIdentique = isSameOrientation(o1,o2)
    o1=o1+90;
    o2=o2+90;
    orientationIdentique=0;
    if abs(o1-o2)<3 || abs(o1-o2)>177
       orientationIdentique=1;
    end
end