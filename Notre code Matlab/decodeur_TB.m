clear all
close all

% Lecture/ecriture du fichier image dans une matrice I
[FILENAME, PATHNAME] = uigetfile('*.jpg');
I=imread(strcat(PATHNAME,FILENAME));
if(size(I,3)>1)
    I=rgb2gray(I);
end
%I=double(I);

% Affichage de l'image avec une barre d'echelle de couleur
figure('numbertitle','off','name','Image')
imagesc(I)
title('Domaine image')
axis square
colormap(gray)
colorbar
pause

Level = graythresh(I);
%Thresholding
ThresholdBarcode=im2bw(I,Level);
% Display the thresholded picture
figure(3) ;
imshow(ThresholdBarcode)
title('Thresholded Picture');
pause

% Spectre obtenu par Transformee de Fourier (fftn) 
% recentree (fftshift) de la matrice I
ITF=fftshift(fftn(ThresholdBarcode));
% Amelioration du contraste de l'image - meilleure lisibilite
ITF2=log(1000+abs(ITF));
%ITF2=abs(ITF);

% Affichage du spectre avec une barre d'echelle de couleur
h = figure('numbertitle','off','name','Spectre');
imagesc(ITF2);
title('Domaine frequentiel')
colormap(gray)
colorbar
pause

Barcode=ITF2;
BarcodeSize = size(ITF2); 
% Find the # of rows and columns
RowNum = BarcodeSize(1); %y
B = floor(RowNum/2);
ColumnNum = BarcodeSize(2); %x 
%% Refine the barcode.
% In each column, if the # of black pixels are more than # of white
% pixels, the entire column will be all black pixel, or vice versa.
J=0;
Q=0;
L=zeros(1,61);

for i = -30:30

    Img1R = imrotate(ITF2,i,'crop');
    colormap(gray);
    q = sum(Img1R(B,:));
    L(1,i+31)=q;
    if q>Q
        J=i;
        Q=q;
    end

end

disp(J)

SpectreRedresse=imrotate(ITF2,J,'crop');
figure; imagesc(SpectreRedresse);

ImageRedressee=imrotate(I,J,'crop');
figure; imagesc(ImageRedressee);

J=0;
Q=0;
for i = -1:0.1:1

    Img1R = imrotate(SpectreRedresse,i,'crop');
    colormap(gray);
    q = sum(Img1R(B,:));
    %figure; imagesc(Img1R);
    %title(q);
    if q>Q
        J=i;
        Q=q;
    end

end

disp(J);
SpectreRedresse2=imrotate(SpectreRedresse,J,'crop');
figure; imagesc(SpectreRedresse2);

ImageRedressee2=imrotate(ImageRedressee,J,'crop');
ImageRedressee2=im2bw(I,Level);
figure; imagesc(ImageRedressee2);