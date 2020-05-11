%EAN13 Barcode Reader
clear all
close all
clc
%% Recuperation de l'image
addpath(genpath('barcode images'));
[im,map]=imread('pates1.PNG');
size(im);
size(map);

barcode=retourne(im);
figure, imshow(barcode);

%% Redimensionnement imcrop(image,[Xmin Ymin Width Height])
nbLignes = size(im,1);
nbColonnes = size(im,2);
barcode_crop=imcrop(im,[0 nbLignes/2 nbColonnes nbLignes/1.2]);
figure, imshow(barcode_crop);

%% Conversion en nuance de gris
barcode_adjust =0.3*im(:,:,1)+0.59*im(:,:,2)+0.11*im(:,:,3);
mapndg=([0:255]/255)'*[1 1 1];
colormap(mapndg);
figure, imshow(barcode_adjust);
figure, imhist(barcode_adjust);  %histogramme mettant en valeur le changement de contraste

%% Augmentation du contraste
barcode_adjust = imadjust(barcode_adjust);
figure, imshow(barcode_adjust);
figure, imhist(barcode_adjust);
%% convolution(application d'un filtre)
NL=size(barcode_adjust,1);
NC=size(barcode_adjust,2);
barcode_adjust=double(barcode_adjust);
masque=[-3 -2 -1;0 0 0;1 2 1]';
imconv=zeros(NL,NC);
W=0.5;
offset=128;
for L=2:NL-1,
    for C=2:NC-1,
        imconv(L,C)=offset+sum(sum(masque.*barcode_adjust(L-1:L+1,C-1:C+1)))/W;
    end
end
image(imconv)
colormap(mapndg)
%% Conversion en noir et blanc, seuillage (thresholding) global (Otsu's method) ou local(adaptative), 
barcode_bw_global = imbinarize(imconv,'global');
figure, imshow(barcode_bw_global);
barcode_bw_adaptive = imbinarize(imconv,'adaptive');
figure, imshow(barcode_bw_adaptive);

%% Corrections de l'image et décodage du code barre
validBarcode = 0;
for i=1:5:size(barcode_bw_global,1)
    %extraction d'une ligne
    ligne=extractLigne(i,barcode_bw_global);

    %calcul le nombre de barres verticales
    numberOfBars=countBars(ligne);

    %tableau contenant la largeur des barres
    widthOfBars=findWidths2(ligne,numberOfBars);

    %donne l'indice de la premiere barre valide (k)
    %et de la dernière barre valide (g)
    [k,g]=findValidBars(widthOfBars);

    %calcul la largeur de la barre élémentaire
    standardWidth=widthOfBars(k);

    %normalise la largeur des barres
    standardWidthOfBars=round(widthOfBars/standardWidth);

    %decodage du code barre s'il semble être correct
    if (numberOfBars-g-k)==57 & standardWidthOfBars(k)==1 & standardWidthOfBars(k+1)==1 & standardWidthOfBars(k+2)==1
        [validBarcode,result]=decode(standardWidthOfBars,k);
    end
    
    %verification de la validité du code barre(chiffre de controle)
    if validBarcode
        disp(result)
        break;
    end
end

%% Ouverture de la page du produit sur open food facts

if ~validBarcode
    disp('c''est un echec, le code barre n''a pas pu etre decode')
else
    result=num2str(result);
    url = strcat('https://fr.openfoodfacts.org/produit/',result);
    web(url);
end