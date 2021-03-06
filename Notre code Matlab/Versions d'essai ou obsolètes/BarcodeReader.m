%EAN13 Barcode Reader
clear all
close all
clc
%% Recuperation de l'image
addpath(genpath('barcode images'));
barcode = imread('perleDeLait4.PNG');
figure, imshow(barcode);

barcode=retourne(barcode);
figure, imshow(barcode);

%% Redimensionnement imcrop(image,[Xmin Ymin Width Height])
nbLignes = size(barcode,1);
nbColonnes = size(barcode,2);
barcode_crop=imcrop(barcode,[0 nbLignes/2 nbColonnes nbLignes/1.2]);
figure, imshow(barcode_crop);

%% Conversion en nuance de gris
barcode_gray = rgb2gray(barcode_crop);
figure, imshow(barcode_gray);
figure, imhist(barcode_gray);   %histogramme mettant en valeur le changement de contraste

%% Augmentation du contraste
barcode_adjust = imadjust(barcode_gray);
figure, imshow(barcode_adjust);
figure, imhist(barcode_adjust);

%% Conversion en noir et blanc, seuillage (thresholding) global (Otsu's method) ou local(adaptative), 
barcode_bw_global = imbinarize(barcode_adjust,'global');
figure, imshow(barcode_bw_global);
barcode_bw_adaptive = imbinarize(barcode_adjust,'adaptive');
figure, imshow(barcode_bw_adaptive);

%% Corrections de l'image et d�codage du code barre
validBarcode = 0;
for i=1:5:size(barcode_bw_global,1)
    %extraction d'une ligne
    ligne=extractLigne(i,barcode_bw_global);

    %calcul le nombre de barres verticales
    numberOfBars=countBars(ligne);

    %tableau contenant la largeur des barres
    widthOfBars=findWidths2(ligne,numberOfBars);

    %donne l'indice de la premiere barre valide (k)
    %et de la derni�re barre valide (g)
    [k,g]=findValidBars(widthOfBars);

    %calcul la largeur de la barre �l�mentaire
    standardWidth=widthOfBars(k);

    %normalise la largeur des barres
    standardWidthOfBars=round(widthOfBars/standardWidth);

    %decodage du code barre s'il semble �tre correct
    if (numberOfBars-g-k)==57 & standardWidthOfBars(k)==1 & standardWidthOfBars(k+1)==1 & standardWidthOfBars(k+2)==1
        [validBarcode,result]=decode(standardWidthOfBars,k);
    end
    
    %verification de la validit� du code barre(chiffre de controle)
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


