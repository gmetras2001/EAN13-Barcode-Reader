%EAN13 Barcode Reader
clear all
close all
clc
%% Recuperation de l'image
addpath(genpath('barcode images'));
barcode = imread('perleDeLait3.PNG');
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

%% Corrections de l'image et décodage du code barre

%extraction d'une ligne
ligne=extractLigne(10,barcode_bw_global);
figure, imshow(ligne);

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

%verification qu'il s'agit bien d'un code barre 
    if (numberOfBars-g-k)==57 & standardWidthOfBars(k)==1 & standardWidthOfBars(k+1)==1 & standardWidthOfBars(k+2)==1
        result=decode(standardWidthOfBars,k)
    end
    
%% Ouverture de la page du produit sur open food facts
% result=num2str(result);
% url = strcat('https://fr.openfoodfacts.org/produit/',result);
% web(url);



