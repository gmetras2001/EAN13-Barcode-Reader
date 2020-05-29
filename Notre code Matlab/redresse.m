function barcode_rotate = redresse(im,stats3)

%%Rotation du code barre
angle_moy = stats3(1).Orientation+90;
for i=2:length(stats3)
    angle_i = stats3(i).Orientation+90;
    if abs(angle_moy-angle_i)>90
        angle_moy = mod((angle_moy+angle_i+180)/2,180);
    else
        angle_moy = (angle_moy+angle_i)/2;
    end
end
angle_moy = 180-angle_moy;
im = imrotate(im,angle_moy);
[m n rgb] = size(im);
 
stats4 = regionprops(im,'Centroid','Extrema');

%On cherche les barres extrêmes à gauche et à droite: plus grand et petit x
Xmin=n;
Xmax=0;
BarreGauche=0;
BarreDroite=0;

for k=1:length(stats4)
    if stats4(k).Centroid(1,1)>Xmax
        Xmax=stats4(k).Centroid(1,1);
        BarreDroite=k;
    end
    if stats4(k).Centroid(1,1)<Xmin
        Xmin=stats4(k).Centroid(1,1);
        BarreGauche=k;
    end
    
end

%On cherche les extrémités des barres encadrant le code à gauche et droite

HautGauche=[min(stats4(BarreGauche).Extrema(1,1),stats4(BarreGauche).Extrema(2,1))-10, min(stats4(BarreGauche).Extrema(1,2),stats4(BarreGauche).Extrema(2,2))]; %Coordonnées en x,y 
BasGauche=[min(stats4(BarreGauche).Extrema(5,1),stats4(BarreGauche).Extrema(6,1))-10, max(stats4(BarreGauche).Extrema(6,2),stats4(BarreGauche).Extrema(5,2))];   %left-bottom

HautDroite=[max(stats4(BarreDroite).Extrema(1,1),stats4(BarreDroite).Extrema(2,1))+10,min(stats4(BarreDroite).Extrema(1,2),stats4(BarreDroite).Extrema(2,2))];  %right-top
BasDroite=[max(stats4(BarreDroite).Extrema(5,1),stats4(BarreDroite).Extrema(6,1))+10, max(stats4(BarreDroite).Extrema(6,2),stats4(BarreDroite).Extrema(5,2))]; %right-bottom

traceRect = @(M) plot(M([1 2 4 3 1],1) ,M([1 2 4 3 1],2), 'r-*');

 
[m n rgb] = size(im);
U=[HautGauche; BasGauche; BasDroite; HautDroite]; %Zone du code à projeter
X = [ 0  0 ;   0 (m) ;  (n)  (m)  ;   (n)   0];   %Rectangle d'arrivée
tform = fitgeotrans(U,X, 'projective');   %Une projection linéaire ou affine ne fonctionne souvent pas
B = imwarp(im, tform);
box = findBoundingBox(B);
ThresholdBarcode=imcrop(B,box);

BarcodeSize = size(ThresholdBarcode);   
RowNum = BarcodeSize(1); %y
RowNum4 = floor(RowNum/4);
ColumnNum = BarcodeSize(2); %x 

%% Redéfinition du code-barres colonne par colonne pour une meilleure lisibilité

 
for i = 1:ColumnNum
   
    BlackCount = sum(ThresholdBarcode(RowNum4:2*RowNum4,i) == 0); % Nombre de pixels noirs de la colonne
    WhiteCount = sum(ThresholdBarcode(RowNum4:2*RowNum4,i) == 1); % Nombre de pixels blancs
    
    %On ne parcourt que la moitié de la hauteur de l'image, centrée sur
    %son milieu. Ainsi, si le code n'occupe pas toute l'image, les moyennes
    %par colonne ne sont pas faussées par des pixels extérieurs au
    %code-barres.
    
    if BlackCount > WhiteCount % On fait une colonne noire
        ThresholdBarcode(:,i) = 0; 
    else
        ThresholdBarcode(:,i) = 1; % colonne blanche
    end
end

    barcode_rotate=ThresholdBarcode;
    figure;
    subplot(1,3,1)
    imshow(im)
    hold on
    plot(polyshape([HautGauche(1,1) BasGauche(1,1) BasDroite(1,1) HautDroite(1,1)],[HautGauche(1,2) BasGauche(1,2) BasDroite(1,2) HautDroite(1,2)]));
subplot(1,3,2)
    imshow(B)
    hold on
    %rectangle('Position',box,'EdgeColor','r')
subplot(1,3,3)
    imshow(ThresholdBarcode)
    
end