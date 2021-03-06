function J=retourne(J)
I=J; %On copie J pour pouvoir conserver l'image de base
if(size(I,3)>1)
    I=rgb2gray(I);
end

%Thresholding
I=im2bw(I,graythresh(I));

BarcodeSize = size(I); 
% Find the # of rows and columns
RowNum = BarcodeSize(1); %y
ColumnNum = BarcodeSize(2); %x 

%On va chercher un point pour commencer � lire l'image
%On le veut dans la plus �troite des barres du code

longColonne=ColumnNum;
y1=floor(RowNum/3);   %fix� arbitrairement � 1/3 de la hauteur de l'image
z=floor(ColumnNum/3);

%On cherche le premier x qui correspond au d�but d'une barre, z
while I(y1,z-1)==I(y1,z)
    z=z+1;
end

k=1; %Largeur de la barre �tudi�e actuellement
x1=z;
%A partir de ce z on parcourt la ligne en cherchant la plus petite bande
for i=z:floor(2*ColumnNum/3)
    if I(y1,i-1)==I(y1,i)
        k=k+1; %La bande est plus large
    else %On a chang� de bande!
        if k<longColonne %Si la bande qu'on vient de parcourir est la plus petite, on enregistre la largeur et on place le d�part dans cette bande
                longColonne=k;
                x1=i-1;
        end
          
       k=1; %On repart avec une nouvelle barre
    end
end

x=x1;
y=y1;

%On incr�mente y � chaque tour pour descendre dans l'image
%On cherche quel x choisir pour rester dans la m�me barre du code

for i=(1:RowNum/3)

    %On cherche la valeur de x pour laquel le pixel en y+1 a la m�me
    %valeur que celui en y
Q1=abs(I(y,x)-I(y+1,x));
Q2=abs(I(y,x)-I(y+1,x-1));
Q3=abs(I(y,x)-I(y,x+1));
Q4=abs(I(y,x)-I(y,x+2));
Q5=abs(I(y,x)-I(y,x-2));
Q6=abs(I(y,x)-I(y,x+3));
Q7=abs(I(y,x)-I(y,x-3));
Q=min([Q1,Q2,Q3,Q4,Q5,Q6,Q7]);
y=y+1;

    switch Q
        
        %On favorise les plus petits x pour ne pas passer � une autre barre
    
    case Q1 %On ne change pas x!
    
    case Q2
       x=x-1;

    case Q3
        x=x+1;
 
    case Q4
        x=x+2;

    case Q5
        x=x-2;
        
     case Q6
        x=x+3;
        
     case Q7
        x=x-3;


    end

end

%On cherche l'angle entre la droite obtenue et la verticale

a=abs(x-x1)/abs(y1-y);
b=atan(a);

alpha=-(b*180/pi);

%On effectue la rotation dans le bon sens 
if x1>x
J=imrotate(J,-alpha,'crop');
end 

if x>x1
J=imrotate(J,alpha,'crop');
end

end 