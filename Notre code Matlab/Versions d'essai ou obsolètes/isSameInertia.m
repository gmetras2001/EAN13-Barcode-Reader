function inertieIdentique = isSameInertia(i1,i2)
    inertieIdentique=0;
    if abs(i1-i2)<[3,3]
        inertieIdentique=1;
    end
end