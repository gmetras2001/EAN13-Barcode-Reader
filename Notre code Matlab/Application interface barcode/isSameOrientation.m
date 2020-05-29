%orientation o1 et o2 entre -90 et 90
function orientationIdentique = isSameOrientation(o1,o2)
    o1=o1+90;
    o2=o2+90;
    orientationIdentique=0;
    if abs(o1-o2)<10 || abs(o1-o2)>170   
       %Sur une photo qui n'est pas parfaitement prise en face, on peut
       %avoir un angle important entre premi�re et derni�re barre du code.
       %La valeur de 10� est un compromis entre s�lectivit� des r�gions et 
       %conservation du code-barres
       orientationIdentique=1;
    end
end