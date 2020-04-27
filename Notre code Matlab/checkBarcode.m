function available = checkBarcode(code, table)
    available = 0;
    s1 = code(1)+code(3)+code(5)+code(7)+code(9)+code(11);
    s2 = table+code(2)+code(4)+code(6)+code(8)+code(10);
    checkDigit = mod(10-mod(3*s1+s2,10),10)
    if checkDigit==code(12)
        available=1;
    end
end