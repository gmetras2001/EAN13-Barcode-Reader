function numOfBars = countBars(ln)
    numOfBars=1;
    for i=1:(length(ln)-1)
        if ln(i)~=ln(i+1)
            numOfBars = numOfBars+1;
        end
    end
end