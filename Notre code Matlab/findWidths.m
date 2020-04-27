function widthBars = findWidths(line, numberBars)
    widthBars = zeros(1,numberBars);
    i=1;
    for k=1:numberBars-1
        width=0;
        if line(i)==0
            while line(i)==0
                width=width+1;
                i=i+1;
            end
        else
            while line(i)==1
                width=width+1;
                i=i+1;
            end
        end
        widthBars(k)=width;
    end
    widthBars(length(widthBars))=length(line)-sum(widthBars());
end