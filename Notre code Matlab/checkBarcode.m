function valid = checkBarcode(code)
    valid = 0;
    s1 = code(2)+code(4)+code(6)+code(8)+code(10)+code(12);
    s2 = code(1)+code(3)+code(5)+code(7)+code(9)+code(11);
    checkDigit = mod(10-mod(3*s1+s2,10),10);
    if checkDigit==code(13)
        valid=1;
    end
end