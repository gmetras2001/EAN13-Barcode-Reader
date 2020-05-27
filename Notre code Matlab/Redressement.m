 clear all
 close all
 
 [FILENAME, PATHNAME] = uigetfile('*.*');
i_rgb=imread(strcat(PATHNAME,FILENAME));
% addpath(genpath('barcode images'));
% i_rgb=imread('lait3.JPG');
%converision en nuance de gris
i_gray = rgb2gray(i_rgb);
% Filtrage morphologique top hat black (mise en évidence du contraste)
se = strel('square',100);
i_black = imbothat(i_gray,se);
%augmentation du contraste
i_adjust = imadjust(i_black);
%conversion en noir et blanc
i_bw = imbinarize(i_adjust);

figure('Name','Pré-traitement')
subplot(3,2,1)
    image(i_rgb)
    title('Image originale')
subplot(3,2,2)
    imshow(i_gray)
    title('Nuances de gris')
subplot(3,2,3)
    imshow(i_black)
    title('Filtre top hat black')
subplot(3,2,4)
    imshow(i_adjust)
    title('Augmentation du contraste')
subplot(3,2,5)
    imshow(i_bw)
    title('Noir et blanc')

%% Extraction du code barre %%
%% Filtrage des régions allongées (rapport longeur/largeur des axes principaux > 10)

%numérotation des régions connexes
[i_regions,n_regions] = bwlabel(i_bw,4);
%calcul des paramètres géométriques des régions
stats1 = regionprops(i_regions,'MinorAxisLength','MajorAxisLength');

d=zeros(length(stats1));
%pour chaque région d'indice k
for k=1:length(stats1)
    if (stats1(k).MajorAxisLength/stats1(k).MinorAxisLength) > 5
        d(k)=k;
    end
end
e=d~=0;
idx_regions_allongees = d(e);

%creation d'une image noir et blanc avec les régions allongées uniquement
i_regions_allongees = ismember(i_regions,idx_regions_allongees);
%numérotation des régions allongées
i_regions_allongees_num = bwlabel(i_regions_allongees);
stats2=regionprops(i_regions_allongees_num,'Centroid','Orientation');

%% Filtrage des régions de meme orientation
orientation_identique=zeros(length(stats2));
a=zeros(1,length(stats2));
for i=1:length(stats2)
    for j=1:length(stats2)
        if isSameOrientation(stats2(i).Orientation,stats2(j).Orientation)
            orientation_identique(i,j) = 1;
        end
    end
    a(i)=sum(orientation_identique(i,:));
end
ligne=1;
for i=2:length(a)
    if a(i)>a(ligne)
        ligne=i;
    end
end
b=zeros(length(orientation_identique));
for i=1:length(orientation_identique)
    if orientation_identique(ligne,i)
        b(i)=i;
    end
end
c=b~=0;
idx_orientation_identique = b(c);
%creation d'une image noir et blanc avec les régions allongées de meme orientation
%uniquement
i_regions_orientation_identique = ismember(i_regions_allongees_num,idx_orientation_identique);
%numérotation des régions de meme orientation
i_regions_orientation_identique_num = bwlabel(i_regions_orientation_identique);
stats3=regionprops(i_regions_orientation_identique_num,'Centroid','Orientation');

%% Filtrage des régions possédant des régions voisines proches

Distance=zeros(1,length(stats3));
Taille=size(i_rgb);
DimensionIm=Taille(1,1);

for i=1:length(stats3)
    Position_i=stats3(i).Centroid;
    voisins=DimensionIm*ones(1,5); %On cherche les 5 voisins les plus proches
    
    for j=1:length(stats3)
        dist=DimensionIm;
        if i~=j
            Position_j=stats3(j).Centroid;
            dist=sqrt((Position_i (1,1)-Position_j (1,1))^2 + (Position_i (1,2)-Position_j (1,2))^2);

            if(dist<voisins(1,5))
                voisins(1,5)=dist;
                voisins=sort(voisins);               
            end
            
        end
            
    end
    
Distance(1,i)=sum(voisins);
    
end

Minimum=min(Distance);
idx=[];

for i=1:length(Distance)
    if Distance(i)<2.25*Minimum   %Le 2.25 est déterminé expérimentalement. Pour une valeur inférieure on commence à supprimer les barres extérieures du code
    idx=[idx i];
    end
end
%creation d'une image noir et blanc avec les régions voisines uniquement
i_regions_voisines = ismember(i_regions_orientation_identique_num,idx);

%% Calcul de la zone ou se trouve le code barre
box = findBoundingBox(i_regions_voisines);

%% Affichage des différentes étapes de l'extraction du code barre

figure('Name','Extraction des codes barrres')
subplot(2,2,1)
    imshow(i_regions);
    title('Image noir et blanc')
subplot(2,2,2)
    imshow(i_regions_allongees)
    title('Filtrage des régions allongées')
    hold on
for k=1:length(stats2)
    txt=texlabel(num2str(k));
    text(stats2(k).Centroid(1),stats2(k).Centroid(2),txt,'Color','r')
end
subplot(2,2,3)
    imshow(i_regions_orientation_identique)
    title('Filtrage grâce à l''orientation')
for k=1:length(stats3)
    txt=texlabel(num2str(k));
    text(stats3(k).Centroid(1),stats3(k).Centroid(2),txt,'Color','r')
end
subplot(2,2,4)
    imshow(i_regions_voisines)
    title('Filtrage des régions voisines')
    hold on
    rectangle('Position',box,'EdgeColor','r')

im=imcrop(i_regions_orientation_identique,box);
figure; imshow(im);
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
%U = [400 900 ; 400 1600 ; 1000 1400 ; 1100 900]
U=[HautGauche; BasGauche; BasDroite; HautDroite];
X = [ 0  0 ;   0 (m) ;  (n)  (m)  ;   (n)   0];
tform = fitgeotrans(U,X, 'projective');
B = imwarp(im, tform);
box = findBoundingBox(B);
ThresholdBarcode=imcrop(B,box);

BarcodeSize = size(ThresholdBarcode);   
RowNum = BarcodeSize(1); %y
ColumnNum = BarcodeSize(2); %x 

%% Refine the barcode.
 %In each column, if the # of black pixels are more than # of white
 %pixels, the entire column will be all black pixel, or vice versa.  
for i = 1:ColumnNum
   
    BlackCount = sum(ThresholdBarcode(:,i) == 0); % define black pixel 
    WhiteCount = sum(ThresholdBarcode(:,i) == 1); % define white pixel
    
    if BlackCount > WhiteCount % make black pixel column
        ThresholdBarcode(:,i) = 0; 
    else
        ThresholdBarcode(:,i) = 1; % make white pixel column
    end
end

    barcode_rotate=im;
    
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
    
%% Décodage
validBarcode = 0;
for i=1:size(barcode_rotate,1)
    %extraction d'une ligne
    ligne=extractLigne(i,barcode_rotate);

    %calcul le nombre de barres verticales
    numberOfBars=countBars(ligne);
    
    %tableau contenant la largeur des barres
    widthOfBars=findWidths2(ligne,numberOfBars);

    %donne l'indice de la premiere barre valide (k)
    %et de la dernière barre valide (g)
    [k,g]=findValidBars(widthOfBars);
        
    if (numberOfBars-g-k)==57

        %calcul la largeur des barres élémentaires
        standardWidth1=(widthOfBars(k)+widthOfBars(k+1)+widthOfBars(k+2))/3;
        standardWidth2=(widthOfBars(k+27)+widthOfBars(k+28)+widthOfBars(k+29)+widthOfBars(k+30)+widthOfBars(k+31))/5;
        standardWidth3=(widthOfBars(k+56)+widthOfBars(k+57)+widthOfBars(k+58))/3;
    
        %applatissement du code barre et normalisation
        x1=[k+1, k+29, k+57];
        y1=[standardWidth1, standardWidth2, standardWidth3];
        p=polyfit(x1,y1,2);
    
        x=k:k+58;
    
        standardWidthOfBars(x)=round(widthOfBars(x)./polyval(p,x));
    
        %decodage du code barre
        [validBarcode,result]=decode(standardWidthOfBars,k);
    
        %verification de la validité du code barre(chiffre de controle)
        if validBarcode
            disp(result)
            break;
        else
            [validBarcode,result]=decode(fliplr(standardWidthOfBars),1);
            if validBarcode
                disp(result)
                break;
            end
        end
    end
end

