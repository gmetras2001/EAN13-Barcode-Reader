function widthBars = findWidths2(line, numberBars)
    widthBars = zeros(1,numberBars);
    k=1;
    width=0;
    for i=1:(length(line)-1)
        if line(i)==line(i+1)
            width=width+1;
        else
            widthBars(k) = width+1;
            width=0;
            k=k+1;
        end
    end
    widthBars(k)=width+1;
end