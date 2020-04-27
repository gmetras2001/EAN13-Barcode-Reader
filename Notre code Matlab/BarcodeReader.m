%EAN13 Barcode Reader

%% Recuperation de l'image
barcode = imread('perleDeLait2.PNG');
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
NumofRows=size(barcode_bw_global,1);
NumofColoms=size(barcode_bw_global,2);
depth=10;
horizantalRule=depth+1;

% for i=1:(horizantalRule-1)
%     c=BYhorizontal(horizantalRule,NumofRows,NumofColoms,I);                 %function# 1
%       
%     td=Region(c);                                                            %function# 2
%    
%     s=Collect(c,td);                                                         %function# 3
%     
%     [k,g]=CheckT(s);                                                          %function# 4
%     
%     rec=s(k);
%     q=s./rec;
%     p=round(q);
%     
%     if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1
%         
%         result=eanupc(p,k)
%     end
% end

%% Ouverture de la page du produit sur open food facts
% result=num2str(result);
% url = strcat('https://fr.openfoodfacts.org/produit/',result);
% web(url);



